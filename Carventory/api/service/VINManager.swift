import Foundation

final class VINManager {

    static let shared = VINManager()

    private let decoder: OfflineVINDecoder

    private init() {
        self.decoder = OfflineVINDecoder()
    }

    // MARK: - Public API

    /// Decode a VIN completely offline.
    ///
    /// - Parameter vin: Vehicle Identification Number
    /// - Returns: A populated Vehicle model
    func vehicle(from vin: String) throws -> Vehicle {

        let normalizedVIN = normalize(vin)

        guard VINValidator.isValid(normalizedVIN) else {
            throw VINError.invalidVIN
        }

        let result = decoder.decode(normalizedVIN)

        return Vehicle(
            id: String(UUID().uuidString),
            vin: normalizedVIN,
            ownerID: "",
            vehicleType: result.vehicleType ?? "",
            make: result.make ?? "",
            model: result.model ?? "",
            modelYear: result.modelYear.map(String.init) ?? "",
            rawVpic: result.rawVpic as! [String : String],
            requiresManualEntry: result.requiresManualEntry,
            createdAt: "",
            updatedAt: "",
            year: result.year ?? 0,
            engine: result.engine ?? "",
            fuelType: result.fuelType ?? "",
            transmission: result.transmission ?? "",
            status: "active",
            countryCode: result.countryCode ?? ""
        )
    }

    /// Decode only the VIN information without creating a Vehicle.
    func decode(_ vin: String) throws -> VINDecodedResult {

        let normalizedVIN = normalize(vin)

        guard VINValidator.isValid(normalizedVIN) else {
            throw VINError.invalidVIN
        }

        return decoder.decode(normalizedVIN)
    }

    /// Check whether a VIN is valid.
    func isValid(_ vin: String) -> Bool {
        let normalizedVIN = normalize(vin)
        return VINValidator.isValid(normalizedVIN)
    }

    // MARK: - Private

    private func normalize(_ vin: String) -> String {
        vin
            .uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}

struct VINDecodedResult {

    let vin: String

    let countryCode: String?

    let vehicleType: String?
    let make: String?
    let model: String?

    let modelYear: Int?
    let year: Int?

    let engine: String?
    let fuelType: String?
    let transmission: String?

    let rawVpic: [String: AnyCodable]

    let requiresManualEntry: Bool
}

enum VINError: LocalizedError {

    case invalidVIN
    case unsupportedVIN
    case databaseNotFound
    case incompleteInformation

    var errorDescription: String? {
        switch self {

        case .invalidVIN:
            return "The VIN is invalid."

        case .unsupportedVIN:
            return "This VIN is not available in the offline vehicle database."

        case .databaseNotFound:
            return "The offline vehicle database could not be loaded."

        case .incompleteInformation:
            return "The VIN was recognized, but some vehicle information is missing."
        }
    }
}

import Foundation

enum VINValidator {

    private static let invalidCharacters: Set<Character> = [
        "I", "O", "Q"
    ]

    static func isValid(_ vin: String) -> Bool {

        guard vin.count == 17 else {
            return false
        }

        let characters = Array(vin)

        for character in characters {

            guard character.isLetter || character.isNumber else {
                return false
            }

            if invalidCharacters.contains(character) {
                return false
            }
        }

        return true
    }
}

import Foundation

final class OfflineVINDecoder {

    private let database: VINDatabase

    init(database: VINDatabase = .shared) {
        self.database = database
    }

    func decode(_ vin: String) -> VINDecodedResult {

        let characters = Array(vin)

        let wmi = String(characters.prefix(3))

        let modelYear = decodeModelYear(
            characters[9]
        )

        let countryCode = database.country(forWMI: wmi)

        let pattern = database.lookup(vin: vin)

        guard let pattern else {

            return VINDecodedResult(
                vin: vin,
                countryCode: countryCode,
                vehicleType: nil,
                make: nil,
                model: nil,
                modelYear: modelYear,
                year: modelYear,
                engine: nil,
                fuelType: nil,
                transmission: nil,
                rawVpic: [:],
                requiresManualEntry: true
            )
        }

        return VINDecodedResult(
            vin: vin,
            countryCode: pattern.countryCode ?? countryCode,
            vehicleType: pattern.vehicleType,
            make: pattern.make,
            model: pattern.model,
            modelYear: pattern.modelYear ?? modelYear,
            year: pattern.modelYear ?? modelYear,
            engine: pattern.engine,
            fuelType: pattern.fuelType,
            transmission: pattern.transmission,
            rawVpic: pattern.rawData as! [String : AnyCodable],
            requiresManualEntry: pattern.requiresManualEntry
        )
    }

    // MARK: - Model Year

    private func decodeModelYear(
        _ character: Character
    ) -> Int? {

        let years: [Character: Int] = [

            "A": 2010,
            "B": 2011,
            "C": 2012,
            "D": 2013,
            "E": 2014,
            "F": 2015,
            "G": 2016,
            "H": 2017,

            "J": 2018,
            "K": 2019,
            "L": 2020,
            "M": 2021,
            "N": 2022,
            "P": 2023,
            "R": 2024,
            "S": 2025,
            "T": 2026,
            "V": 2027,
            "W": 2028,
            "X": 2029,
            "Y": 2030,

            "1": 2031,
            "2": 2032,
            "3": 2033,
            "4": 2034,
            "5": 2035,
            "6": 2036,
            "7": 2037,
            "8": 2038,
            "9": 2039
        ]

        return years[character]
    }
}

struct VINPattern {

    let prefix: String

    let countryCode: String?

    let make: String
    let model: String

    let vehicleType: String

    let modelYear: Int?

    let engine: String?
    let fuelType: String?
    let transmission: String?

    let rawData: [String: String]

    let requiresManualEntry: Bool
}


import Foundation

final class VINDatabase {

    static let shared = VINDatabase()

    private var patterns: [VINPattern] = []

    private init() {
        loadDatabase()
    }

    // MARK: - Lookup

    func lookup(vin: String) -> VINPattern? {

        // Longest prefix wins.
        patterns
            .filter {
                vin.hasPrefix($0.prefix)
            }
            .max {
                $0.prefix.count < $1.prefix.count
            }
    }

    func country(forWMI wmi: String) -> String? {

        switch wmi {

        case "KMH", "KM8", "KMF", "KNA":
            return "KR"

        case "1HG", "1FT", "1FA":
            return "US"

        case "JTD", "JHM", "JTE":
            return "JP"

        case "WVW", "WBA", "WDB":
            return "DE"

        default:
            return nil
        }
    }

    // MARK: - Load

    private func loadDatabase() {

        patterns = [

            VINPattern(
                prefix: "KMHC85LCXHU",
                countryCode: "KR",
                make: "Hyundai",
                model: "Ioniq",
                vehicleType: "Passenger Car",
                modelYear: 2017,
                engine: "1.6L 4-Cylinder",
                fuelType: "Gasoline",
                transmission: nil,
                rawData: [
                    "VINPrefix": "KMHC85LCXHU",
                    "Make": "Hyundai",
                    "Model": "Ioniq",
                    "ModelYear": "2017",
                    "Engine": "1.6L 4-Cylinder",
                    "FuelType": "Gasoline"
                ],
                requiresManualEntry: false
            )

        ]
    }
}
