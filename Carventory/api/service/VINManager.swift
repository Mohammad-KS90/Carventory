//
//  VINManager.swift
//  Carventory
//
//  Offline VIN decoding using:
//  - VIN structural validation
//  - VIN check digit validation
//  - WMI manufacturer/country lookup
//  - Curated VDS patterns from vin_patterns.json
//  - Generic model-year decoding
//
//  Curated patterns match VIN positions 1-8 (WMI + VDS).
//  Position 9 is the check digit and must NOT be part of a
//  generalized vehicle/model pattern.
//

import Foundation

// MARK: - Public Entry Point

final class VINManager {

    static let shared = VINManager()

    private let decoder: OfflineVINDecoder

    private init() {
        self.decoder = OfflineVINDecoder()
    }

    // MARK: Vehicle

    func vehicle(from vin: String) throws -> Vehicle {

        let normalizedVIN = normalize(vin)

        guard VINValidator.isValid(normalizedVIN) else {
            throw VINError.invalidVIN
        }

        let result = decoder.decode(normalizedVIN)

        return Vehicle(
            id: UUID().uuidString,
            vin: normalizedVIN,
            ownerID: "",
            vehicleType: result.vehicleType ?? "",
            make: result.make ?? "",
            model: result.model ?? "",
            modelYear: result.modelYear.map(String.init) ?? "",
            rawVpic: result.rawVpic as? [String: String] ?? [:],
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

    // MARK: Decode

    func decode(_ vin: String) throws -> VINDecodedResult {

        let normalizedVIN = normalize(vin)

        guard VINValidator.isValid(normalizedVIN) else {
            throw VINError.invalidVIN
        }

        return decoder.decode(normalizedVIN)
    }

    // MARK: Validation

    func isValid(_ vin: String) -> Bool {
        VINValidator.isValid(normalize(vin))
    }

    // MARK: Normalize

    private func normalize(_ vin: String) -> String {

        vin
            .uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}

// MARK: - Vehicle Body Type

enum VehicleBodyType {

    case sedan
    case hatchback
    case wagon
    case coupe
    case convertible
    case suv
    case crossover
    case pickup
    case van
    case minivan
    case truck
    case tractor
    case bus
    case motorcycle
    case scooter
    case trailer
    case unknown
}

// MARK: - Vehicle Category

enum VehicleCategory {

    case passenger
    case commercial
    case motorcycle
    case trailer
    case specialPurpose
}

// MARK: - VIN Vehicle Type

enum VINVehicleType: String, Codable, Hashable {

    case passengerCar
    case suv
    case pickup
    case van
    case minivan
    case truck
    case heavyTruck
    case tractor
    case bus
    case motorcycle
    case moped
    case trailer
    case semiTrailer
    case electricVehicle
    case hybridVehicle
    case specialPurpose
    case unknown
}

// MARK: - Decode Confidence

enum VINDecodeConfidence: String, Codable {

    case exact
    case manufacturer
    case wmi
    case yearOnly
    case unknown
}

// MARK: - VIN Decoded Result

struct VINDecodedResult {

    let vin: String

    // Geographic / manufacturer information
    let countryCode: String?
    let plantCode: String?

    // Vehicle identification
    let vehicleType: String?
    let make: String?
    let model: String?

    // Year
    let modelYear: Int?
    let year: Int?

    // Technical information
    let engine: String?
    let fuelType: String?
    let transmission: String?

    // Raw decoded information
    let rawVpic: [String: AnyCodable]

    // Decode quality
    let confidence: VINDecodeConfidence
    let requiresManualEntry: Bool

    // Strongly typed vehicle category
    let VINVehicleType: VINVehicleType
}

// MARK: - VDS Rule

struct VINVDSRule {

    let pattern: String

    let vehicleType: VINVehicleType

    let make: String
    let model: String?

    let engine: String?
    let fuelType: String?
    let transmission: String?

    let years: ClosedRange<Int>?
}

// MARK: - Manufacturer Profile

struct VINManufacturerProfile {

    let wmi: String
    let manufacturer: String
    let country: String

    let vehicleTypes: Set<VINVehicleType>

    let vdsRules: [VINVDSRule]

    let plantCodes: [String: String]
}

// MARK: - VIN Errors

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

// MARK: - VIN Validation

enum VINValidator {

    private static let allowedCharacters =
        CharacterSet(
            charactersIn: "ABCDEFGHJKLMNPRSTUVWXYZ0123456789"
        )

    // MARK: Basic Validation

    static func isValid(_ vin: String) -> Bool {

        validate(
            vin,
            level: .structural
        )
    }

    // MARK: Validation Levels

    static func validate(
        _ vin: String,
        level: VINValidationLevel = .structural
    ) -> Bool {

        guard validateStructure(vin) else {
            return false
        }

        switch level {

        case .structural:
            return true

        case .checkDigit:
            return validateCheckDigit(vin)

        case .strict:
            return validateCheckDigit(vin)
        }
    }

    // MARK: Structure

    private static func validateStructure(_ vin: String) -> Bool {

        guard vin.count == 17 else {
            return false
        }

        return vin.unicodeScalars.allSatisfy {
            allowedCharacters.contains($0)
        }
    }

    // MARK: North American Check Digit

    private static func validateCheckDigit(_ vin: String) -> Bool {

        guard vin.count == 17 else {
            return false
        }

        let characters = Array(vin)

        let transliteration: [Character: Int] = [

            "A": 1,
            "B": 2,
            "C": 3,
            "D": 4,
            "E": 5,
            "F": 6,
            "G": 7,
            "H": 8,

            "J": 1,
            "K": 2,
            "L": 3,
            "M": 4,
            "N": 5,

            "P": 7,
            "R": 9,

            "S": 2,
            "T": 3,
            "U": 4,
            "V": 5,
            "W": 6,
            "X": 7,
            "Y": 8,
            "Z": 9
        ]

        // VIN positions 1-17
        // Position 9 has weight 0 because it is the check digit.
        let weights = [
            8,  // 1
            7,  // 2
            6,  // 3
            5,  // 4
            4,  // 5
            3,  // 6
            2,  // 7
            10, // 8
            0,  // 9 - check digit
            9,  // 10
            8,  // 11
            7,  // 12
            6,  // 13
            5,  // 14
            4,  // 15
            3,  // 16
            2   // 17
        ]

        guard weights.count == characters.count else {
            return false
        }

        var total = 0

        for index in 0..<17 {

            let character = characters[index]

            let value: Int

            if let digit = character.wholeNumberValue {

                value = digit

            } else if let letterValue = transliteration[character] {

                value = letterValue

            } else {

                return false
            }

            total += value * weights[index]
        }

        let remainder = total % 11

        let expectedCheckDigit: Character =
            remainder == 10
            ? "X"
            : Character(String(remainder))

        return characters[8] == expectedCheckDigit
    }
}

// MARK: - VIN Structure

struct VINStructure {

    let raw: String

    // Positions 1-3
    var wmi: String {
        String(raw.prefix(3))
    }

    // Positions 4-8
    var vds: String {
        String(raw.dropFirst(3).prefix(5))
    }

    // Position 9
    var checkDigit: Character {
        raw[raw.index(raw.startIndex, offsetBy: 8)]
    }

    // Position 10
    var modelYearCode: Character {
        raw[raw.index(raw.startIndex, offsetBy: 9)]
    }

    // Position 11
    var plantCode: Character {
        raw[raw.index(raw.startIndex, offsetBy: 10)]
    }

    // Positions 10-17
    var vis: String {
        String(raw.dropFirst(9))
    }

    // Positions 12-17
    var serialNumber: String {
        String(raw.suffix(6))
    }

    init?(_ vin: String) {

        guard vin.count == 17 else {
            return nil
        }

        self.raw = vin
    }
}

// MARK: - VIN Validation Level

enum VINValidationLevel {

    case structural
    case checkDigit
    case strict
}

// MARK: - Offline VIN Decoder

final class OfflineVINDecoder {

    private let database: VINDatabase

    init(database: VINDatabase = .shared) {
        self.database = database
    }

    // MARK: Decode

    func decode(_ vin: String) -> VINDecodedResult {

        guard let structure = VINStructure(vin) else {

            return VINDecodedResult(
                vin: vin,
                countryCode: nil,
                plantCode: nil,
                vehicleType: nil,
                make: nil,
                model: nil,
                modelYear: nil,
                year: nil,
                engine: nil,
                fuelType: nil,
                transmission: nil,
                rawVpic: [:],
                confidence: .unknown,
                requiresManualEntry: true,
                VINVehicleType: .unknown
            )
        }

        let wmi = structure.wmi

        let modelYear = decodeModelYear(
            yearChar: structure.modelYearCode,
            disambiguationChar: vin[
                vin.index(
                    vin.startIndex,
                    offsetBy: 6
                )
            ]
        )

        // ---------------------------------------------------------
        // Tier 1
        // Exact curated pattern
        // ---------------------------------------------------------

        if let pattern = database.lookup(vin: vin) {

            let typedVehicleType =
                VINVehicleType(
                    rawValue: pattern.vehicleType
                ) ?? .unknown

            let country =
                pattern.countryCode
                ?? database.country(forWMI: wmi)

            let plantCode =
                structure.plantCode == " "
                ? nil
                : String(structure.plantCode)

            let resolvedYear =
                pattern.modelYear ?? modelYear

            return VINDecodedResult(

                vin: vin,

                countryCode: country,

                plantCode: plantCode,

                vehicleType: pattern.vehicleType,

                make: pattern.make,

                model: pattern.model,

                modelYear: resolvedYear,

                year: resolvedYear,

                engine: pattern.engine,

                fuelType: pattern.fuelType,

                transmission: pattern.transmission,

                rawVpic: pattern.rawData,

                confidence: .exact,

                requiresManualEntry:
                    pattern.requiresManualEntry,

                VINVehicleType:
                    typedVehicleType
            )
        }

        // ---------------------------------------------------------
        // Tier 2
        // WMI manufacturer lookup
        // ---------------------------------------------------------

        if let wmiEntry = database.wmiEntry(for: wmi) {

            return VINDecodedResult(

                vin: vin,

                countryCode: wmiEntry.country,

                plantCode: String(structure.plantCode),

                vehicleType: nil,

                make: wmiEntry.make,

                model: nil,

                modelYear: modelYear,

                year: modelYear,

                engine: nil,

                fuelType: nil,

                transmission: nil,

                rawVpic: [

                    "WMI": AnyCodable(wmi),

                    "Make": AnyCodable(wmiEntry.make),

                    "Country": AnyCodable(wmiEntry.country),

                    "VDS": AnyCodable(structure.vds),

                    "ModelYearCode":
                        AnyCodable(
                            String(structure.modelYearCode)
                        ),

                    "PlantCode":
                        AnyCodable(
                            String(structure.plantCode)
                        ),

                    "SerialNumber":
                        AnyCodable(
                            structure.serialNumber
                        )
                ],

                confidence: .wmi,

                requiresManualEntry: true,

                VINVehicleType: .unknown
            )
        }

        // ---------------------------------------------------------
        // Tier 3
        // Model year only
        // ---------------------------------------------------------

        if let modelYear {

            return VINDecodedResult(

                vin: vin,

                countryCode: nil,

                plantCode: String(structure.plantCode),

                vehicleType: nil,

                make: nil,

                model: nil,

                modelYear: modelYear,

                year: modelYear,

                engine: nil,

                fuelType: nil,

                transmission: nil,

                rawVpic: [

                    "VDS":
                        AnyCodable(structure.vds),

                    "ModelYearCode":
                        AnyCodable(
                            String(structure.modelYearCode)
                        ),

                    "PlantCode":
                        AnyCodable(
                            String(structure.plantCode)
                        ),

                    "SerialNumber":
                        AnyCodable(
                            structure.serialNumber
                        )
                ],

                confidence: .yearOnly,

                requiresManualEntry: true,

                VINVehicleType: .unknown
            )
        }

        // ---------------------------------------------------------
        // Tier 4
        // Completely unknown VIN
        // ---------------------------------------------------------

        return VINDecodedResult(

            vin: vin,

            countryCode: nil,

            plantCode: String(structure.plantCode),

            vehicleType: nil,

            make: nil,

            model: nil,

            modelYear: nil,

            year: nil,

            engine: nil,

            fuelType: nil,

            transmission: nil,

            rawVpic: [:],

            confidence: .unknown,

            requiresManualEntry: true,

            VINVehicleType: .unknown
        )
    }

    // MARK: Model Year

    private func decodeModelYear(
        yearChar: Character,
        disambiguationChar: Character
    ) -> Int? {

        let modernCycle: [Character: Int] = [

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

        let legacyCycle: [Character: Int] = [

            "A": 1980,
            "B": 1981,
            "C": 1982,
            "D": 1983,
            "E": 1984,
            "F": 1985,
            "G": 1986,
            "H": 1987,
            "J": 1988,
            "K": 1989,
            "L": 1990,
            "M": 1991,
            "N": 1992,
            "P": 1993,
            "R": 1994,
            "S": 1995,
            "T": 1996,
            "V": 1997,
            "W": 1998,
            "X": 1999,
            "Y": 2000,

            "1": 2001,
            "2": 2002,
            "3": 2003,
            "4": 2004,
            "5": 2005,
            "6": 2006,
            "7": 2007,
            "8": 2008,
            "9": 2009
        ]

        if disambiguationChar.isNumber {
            return legacyCycle[yearChar]
        }

        return modernCycle[yearChar]
    }
}

// MARK: - Curated VIN Pattern

struct VINPattern {

    /// VIN positions 1-8.
    /// Never include position 9 check digit.
    let prefix: String

    let countryCode: String?

    let make: String
    let model: String

    let vehicleType: String

    let modelYear: Int?

    let engine: String?
    let fuelType: String?
    let transmission: String?

    let rawData: [String: AnyCodable]

    let requiresManualEntry: Bool
}

// MARK: - VIN Pattern DTO

private struct VINPatternDTO: Decodable {

    let prefix: String

    let countryCode: String?

    let make: String
    let model: String

    let vehicleType: String

    let modelYear: Int?

    let engine: String?
    let fuelType: String?
    let transmission: String?

    let requiresManualEntry: Bool

    let rawData: [String: String]?

    func toVINPattern() -> VINPattern {

        VINPattern(

            prefix: prefix,

            countryCode: countryCode,

            make: make,

            model: model,

            vehicleType: vehicleType,

            modelYear: modelYear,

            engine: engine,

            fuelType: fuelType,

            transmission: transmission,

            rawData:
                (rawData ?? [:])
                    .mapValues {
                        AnyCodable($0)
                    },

            requiresManualEntry:
                requiresManualEntry
        )
    }
}

// MARK: - WMI Entry

struct WMIEntry {

    let make: String
    let country: String
}

// MARK: - VIN Database

final class VINDatabase {

    static let shared = VINDatabase()

    private var patterns: [VINPattern] = []

    private var wmiTable: [String: WMIEntry] = [:]

    private init() {

        loadCuratedPatterns()

        loadWMITable()
    }

    // MARK: Lookup

    /// Longest matching prefix wins.
    ///
    /// Normally prefixes contain VIN positions 1-8.
    /// Longer prefixes may be used for manufacturer-specific
    /// exceptions.
    func lookup(vin: String) -> VINPattern? {

        patterns
            .filter {
                vin.hasPrefix($0.prefix)
            }
            .max {
                $0.prefix.count < $1.prefix.count
            }
    }

    // MARK: Country

    func country(forWMI wmi: String) -> String? {

        wmiTable[wmi]?.country
    }

    // MARK: WMI

    func wmiEntry(for wmi: String) -> WMIEntry? {

        wmiTable[wmi]
    }

    // MARK: Load Curated Patterns

    private func loadCuratedPatterns() {

        guard
            let url = Bundle.main.url(
                forResource: "vin_patterns",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url)
        else {

            patterns = []

            return
        }

        do {

            let dtos =
                try JSONDecoder()
                    .decode(
                        [VINPatternDTO].self,
                        from: data
                    )

            patterns =
                dtos.map {
                    $0.toVINPattern()
                }

        } catch {

            print(
                "VINDatabase: failed to decode vin_patterns.json — \(error)"
            )

            patterns = []
        }
    }

    // MARK: WMI Table

    private func loadWMITable() {

        let entries: [(String, String, String)] = [

            // -------------------------------------------------
            // USA
            // -------------------------------------------------

            ("1FA", "Ford", "US"),
            ("1FB", "Ford", "US"),
            ("1FC", "Ford", "US"),
            ("1FD", "Ford", "US"),
            ("1FM", "Ford", "US"),
            ("1FT", "Ford", "US"),

            ("1G1", "Chevrolet", "US"),
            ("1G4", "Buick", "US"),
            ("1G6", "Cadillac", "US"),
            ("1GC", "Chevrolet", "US"),
            ("1GT", "GMC", "US"),

            ("1HD", "Harley-Davidson", "US"),

            ("1HG", "Honda", "US"),
            ("1HT", "International", "US"),

            ("1J4", "Jeep", "US"),
            ("1J8", "Jeep", "US"),

            ("1L1", "Lincoln", "US"),

            ("1N4", "Nissan", "US"),
            ("1N6", "Nissan", "US"),

            ("1VW", "Volkswagen", "US"),
            ("1YV", "Mazda", "US"),

            ("4F2", "Mazda", "US"),
            ("4F4", "Mazda", "US"),

            ("4S3", "Subaru", "US"),
            ("4S4", "Subaru", "US"),

            ("4T1", "Toyota", "US"),
            ("4T3", "Toyota", "US"),

            ("4US", "BMW", "US"),

            ("5FN", "Honda", "US"),
            ("5J6", "Honda", "US"),
            ("5NP", "Hyundai", "US"),

            ("5TD", "Toyota", "US"),
            ("5TF", "Toyota", "US"),

            ("5UX", "BMW", "US"),
            ("5YM", "BMW", "US"),

            ("5XY", "Kia", "US"),

            // -------------------------------------------------
            // CANADA
            // -------------------------------------------------

            ("2C3", "Chrysler", "CA"),
            ("2C4", "Dodge", "CA"),

            ("2FA", "Ford", "CA"),
            ("2FM", "Ford", "CA"),
            ("2FT", "Ford", "CA"),

            ("2G1", "Chevrolet", "CA"),
            ("2G4", "Buick", "CA"),

            ("2HG", "Honda", "CA"),
            ("2HK", "Honda", "CA"),

            ("2T1", "Toyota", "CA"),
            ("2T2", "Toyota", "CA"),

            // -------------------------------------------------
            // MEXICO
            // -------------------------------------------------

            ("3FA", "Ford", "MX"),
            ("3FE", "Ford", "MX"),

            ("3G1", "Chevrolet", "MX"),
            ("3GN", "Chevrolet", "MX"),

            ("3N1", "Nissan", "MX"),
            ("3N6", "Nissan", "MX"),

            ("3VW", "Volkswagen", "MX"),

            // -------------------------------------------------
            // AUSTRALIA
            // -------------------------------------------------

            ("6F4", "Ford", "AU"),

            ("6G1", "Holden", "AU"),
            ("6G2", "Holden", "AU"),

            ("6H8", "Toyota", "AU"),
            ("6T1", "Toyota", "AU"),

            ("6U9", "General Motors", "AU"),

            // -------------------------------------------------
            // JAPAN
            // -------------------------------------------------

            ("JHM", "Honda", "JP"),

            ("JA3", "Mitsubishi", "JP"),
            ("JA4", "Mitsubishi", "JP"),

            ("JF1", "Subaru", "JP"),
            ("JF2", "Subaru", "JP"),

            ("JH4", "Acura", "JP"),

            ("JM1", "Mazda", "JP"),
            ("JM3", "Mazda", "JP"),
            ("JM6", "Mazda", "JP"),
            ("JM7", "Mazda", "JP"),

            ("JN1", "Nissan", "JP"),
            ("JN6", "Nissan", "JP"),
            ("JN8", "Nissan", "JP"),

            ("JS2", "Suzuki", "JP"),
            ("JS3", "Suzuki", "JP"),
            ("JS4", "Suzuki", "JP"),

            ("JT2", "Toyota", "JP"),
            ("JT3", "Toyota", "JP"),
            ("JT4", "Toyota", "JP"),
            ("JT6", "Toyota", "JP"),
            ("JT8", "Toyota", "JP"),

            ("JTD", "Toyota", "JP"),
            ("JTE", "Toyota", "JP"),
            ("JTF", "Toyota", "JP"),
            ("JTG", "Toyota", "JP"),

            ("JTH", "Lexus", "JP"),
            ("JTJ", "Lexus", "JP"),

            ("JTK", "Toyota", "JP"),
            ("JTL", "Toyota", "JP"),
            ("JTM", "Toyota", "JP"),
            ("JTN", "Toyota", "JP"),

            // -------------------------------------------------
            // SOUTH KOREA
            // -------------------------------------------------

            ("KL1", "Daewoo/GM Korea", "KR"),
            ("KL4", "Daewoo/GM Korea", "KR"),
            ("KL5", "Daewoo/GM Korea", "KR"),
            ("KL7", "Daewoo/GM Korea", "KR"),
            ("KL8", "Daewoo/GM Korea", "KR"),

            ("KM8", "Hyundai", "KR"),
            ("KMH", "Hyundai", "KR"),
            ("KMF", "Hyundai", "KR"),
            ("KMY", "Hyundai", "KR"),

            ("KMC", "Kia", "KR"),

            ("KN1", "Kia", "KR"),
            ("KNA", "Kia", "KR"),
            ("KNC", "Kia", "KR"),
            ("KND", "Kia", "KR"),
            ("KNE", "Kia", "KR"),
            ("KNJ", "Kia", "KR"),

            ("KNM", "Renault Samsung", "KR"),

            ("RL0", "Renault Samsung", "KR"),

            // -------------------------------------------------
            // CHINA
            // -------------------------------------------------

            ("LFV", "FAW-Volkswagen", "CN"),
            ("LFB", "FAW", "CN"),

            ("LDC", "Dongfeng Honda", "CN"),
            ("LGH", "GAC Honda", "CN"),

            ("LHB", "Beijing Hyundai", "CN"),

            ("LSJ", "MG/SAIC", "CN"),
            ("LSY", "BYD", "CN"),
            ("LBE", "BYD", "CN"),

            ("LVS", "Ford", "CN"),
            ("LJD", "Dongfeng", "CN"),

            ("L6T", "Foton", "CN"),

            ("LGB", "Buick (SAIC-GM)", "CN"),

            ("LGX", "Geely", "CN"),

            // -------------------------------------------------
            // INDIA
            // -------------------------------------------------

            ("MA1", "Maruti Suzuki", "IN"),
            ("MA3", "Maruti Suzuki", "IN"),
            ("MA6", "Maruti Suzuki", "IN"),
            ("MA7", "Maruti Suzuki", "IN"),

            ("MAJ", "Ford", "IN"),
            ("MAT", "Tata Motors", "IN"),

            ("MB8", "Mahindra", "IN"),
            ("MBJ", "Toyota Kirloskar", "IN"),

            // -------------------------------------------------
            // THAILAND
            // -------------------------------------------------

            ("MR0", "Toyota", "TH"),
            ("MRH", "Honda", "TH"),

            ("PE1", "Ford", "TH"),
            ("PN1", "Nissan", "TH"),

            // -------------------------------------------------
            // MALAYSIA
            // -------------------------------------------------

            ("PL1", "Proton", "MY"),

            // -------------------------------------------------
            // UNITED KINGDOM
            // -------------------------------------------------

            ("SAJ", "Jaguar", "GB"),
            ("SAL", "Land Rover", "GB"),
            ("SAR", "Rover", "GB"),

            ("SB1", "Toyota", "GB"),

            ("SCC", "Lotus", "GB"),
            ("SCB", "Bentley", "GB"),

            ("SDB", "Peugeot", "GB"),
            ("SEY", "LDV", "GB"),

            ("SFA", "Ford", "GB"),

            ("SHH", "Honda", "GB"),
            ("SHS", "Honda", "GB"),

            ("SJN", "Nissan", "GB"),

            // -------------------------------------------------
            // CZECH REPUBLIC
            // -------------------------------------------------

            ("TMA", "Škoda", "CZ"),
            ("TMB", "Škoda", "CZ"),

            // -------------------------------------------------
            // HUNGARY
            // -------------------------------------------------

            ("TRU", "Audi", "HU"),
            ("TSM", "Suzuki", "HU"),

            // -------------------------------------------------
            // FRANCE
            // -------------------------------------------------

            ("VF1", "Renault", "FR"),
            ("VF3", "Peugeot", "FR"),
            ("VF6", "Renault", "FR"),
            ("VF7", "Citroën", "FR"),
            ("VF8", "Peugeot", "FR"),
            ("VF9", "Bugatti", "FR"),

            ("VNK", "Toyota", "FR"),
            ("VNV", "Renault Trucks/Nissan", "FR"),

            // -------------------------------------------------
            // SPAIN
            // -------------------------------------------------

            ("VSS", "SEAT", "ES"),
            ("VSE", "Suzuki (Santana)", "ES"),

            // -------------------------------------------------
            // GERMANY
            // -------------------------------------------------

            ("WA1", "Audi", "DE"),
            ("WAU", "Audi", "DE"),

            ("WBA", "BMW", "DE"),
            ("WBS", "BMW M", "DE"),
            ("WBX", "BMW", "DE"),
            ("WBY", "BMW", "DE"),

            ("WDB", "Mercedes-Benz", "DE"),
            ("WDC", "Mercedes-Benz", "DE"),
            ("WDD", "Mercedes-Benz", "DE"),
            ("WDF", "Mercedes-Benz", "DE"),
            ("WDY", "Mercedes-Benz", "DE"),

            ("WEB", "EvoBus", "DE"),

            ("WF0", "Ford", "DE"),

            ("WMA", "MINI", "DE"),
            ("WMW", "MINI", "DE"),

            ("WME", "smart", "DE"),

            ("WP0", "Porsche", "DE"),
            ("WP1", "Porsche", "DE"),

            ("WUA", "Audi Sport", "DE"),

            ("WVG", "Volkswagen", "DE"),
            ("WVW", "Volkswagen", "DE"),

            ("WV1", "Volkswagen", "DE"),
            ("WV2", "Volkswagen", "DE"),

            // -------------------------------------------------
            // RUSSIA
            // -------------------------------------------------

            ("XTA", "Lada (AvtoVAZ)", "RU"),
            ("XW8", "Volkswagen", "RU"),

            ("XWB", "Hyundai", "RU"),
            ("XWE", "Kia", "RU"),

            // -------------------------------------------------
            // SWEDEN
            // -------------------------------------------------

            ("YS3", "Saab", "SE"),

            ("YV1", "Volvo", "SE"),
            ("YV4", "Volvo", "SE"),

            // -------------------------------------------------
            // ITALY
            // -------------------------------------------------

            ("ZAM", "Maserati", "IT"),
            ("ZAR", "Alfa Romeo", "IT"),

            ("ZCF", "Iveco", "IT"),

            ("ZD0", "Fiat", "IT"),
            ("ZD3", "Fiat", "IT"),
            ("ZD4", "Fiat", "IT"),

            ("ZFA", "Fiat", "IT"),

            ("ZFF", "Ferrari", "IT"),

            ("ZLA", "Lancia", "IT")
        ]

        for (wmi, make, country) in entries {

            wmiTable[wmi] =
                WMIEntry(
                    make: make,
                    country: country
                )
        }
    }
}

// MARK: - Test

func testVINManager() {

    let vin = "1HGCM82633A004352"

    guard let structure = VINStructure(vin) else {
        print("Invalid VIN structure")
        return
    }

    print("VIN: \(structure.raw)")
    print("WMI: \(structure.wmi)")
    print("VDS: \(structure.vds)")
    print("Check Digit: \(structure.checkDigit)")
    print("Model Year Code: \(structure.modelYearCode)")
    print("Plant Code: \(structure.plantCode)")
    print("VIS: \(structure.vis)")
    print("Serial Number: \(structure.serialNumber)")

    let structuralValid =
        VINValidator.validate(
            vin,
            level: .structural
        )

    let checkDigitValid =
        VINValidator.validate(
            vin,
            level: .checkDigit
        )

    print("Structural Valid: \(structuralValid)")
    print("Check Digit Valid: \(checkDigitValid)")
}
