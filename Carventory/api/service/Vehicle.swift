import Foundation

struct Vehicle: Codable {
    let id, vin, ownerID, vehicleType: String
    let make, model, modelYear: String
    let rawVpic: [String: String]
    let requiresManualEntry: Bool
    let createdAt: String?
    let updatedAt: String?
    let year: Int
    let engine, fuelType, transmission, status: String
    let countryCode: String

    enum CodingKeys: String, CodingKey {
        case id, vin
        case ownerID = "owner_id"
        case vehicleType = "vehicle_type"
        case make, model
        case modelYear = "model_year"
        case rawVpic = "raw_vpic"
        case requiresManualEntry = "requires_manual_entry"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case year, engine
        case fuelType = "fuel_type"
        case transmission, status
        case countryCode = "country_code"
    }
}

//struct Vehicle: Codable, Identifiable {
//    let id: String
//    let vin: String
//    let ownerId: String
//    let vehicleType: String
//
//    let make: String?
//    let model: String?
//    let modelYear: String?
//
//    let rawVpic: [String: String?]?
//
//    let requiresManualEntry: Bool
//    let createdAt: Date
//    let updatedAt: Date?
//
//    let year: Int?
//    let engine: String?
//    let fuelType: String?
//    let transmission: String?
//
//    let status: String
//    let countryCode: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case vin
//        case ownerId = "owner_id"
//        case vehicleType = "vehicle_type"
//
//        case make
//        case model
//        case modelYear = "model_year"
//
//        case rawVpic = "raw_vpic"
//
//        case requiresManualEntry = "requires_manual_entry"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//
//        case year
//        case engine
//        case fuelType = "fuel_type"
//        case transmission
//
//        case status
//        case countryCode = "country_code"
//    }
//}

import Foundation

//struct AnyCodable: Codable {
//
//    let value: Any
//
//    init(_ value: Any) {
//        self.value = value
//    }
//
//    init(from decoder: Decoder) throws {
//
//        let container = try decoder.singleValueContainer()
//
//        if container.decodeNil() {
//            self.value = NSNull()
//        } else if let value = try? container.decode(Bool.self) {
//            self.value = value
//        } else if let value = try? container.decode(Int.self) {
//            self.value = value
//        } else if let value = try? container.decode(Double.self) {
//            self.value = value
//        } else if let value = try? container.decode(String.self) {
//            self.value = value
//        } else if let value = try? container.decode([AnyCodable].self) {
//            self.value = value.map(\.value)
//        } else if let value = try? container.decode([String: AnyCodable].self) {
//            self.value = value.mapValues(\.value)
//        } else {
//            throw DecodingError.dataCorruptedError(
//                in: container,
//                debugDescription: "Unsupported JSON value"
//            )
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//
//        var container = encoder.singleValueContainer()
//
//        switch value {
//
//        case is NSNull:
//            try container.encodeNil()
//
//        case let value as Bool:
//            try container.encode(value)
//
//        case let value as Int:
//            try container.encode(value)
//
//        case let value as Double:
//            try container.encode(value)
//
//        case let value as String:
//            try container.encode(value)
//
//        case let value as [Any]:
//            try container.encode(
//                value.map(AnyCodable.init)
//            )
//
//        case let value as [String: Any]:
//            try container.encode(
//                value.mapValues(AnyCodable.init)
//            )
//
//        default:
//            throw EncodingError.invalidValue(
//                value,
//                EncodingError.Context(
//                    codingPath: container.codingPath,
//                    debugDescription: "Unsupported JSON value"
//                )
//            )
//        }
//    }
//}

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else {
            value = ""
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as String: try container.encode(v)
        case let v as Int: try container.encode(v)
        case let v as Double: try container.encode(v)
        case let v as Bool: try container.encode(v)
        default: try container.encodeNil()
        }
    }
}

/*
 {
   "id": "7d747384-7766-4d48-b8bd-7e3f9beb71aa",
   "vin": "KMHC85LCXHU026758",
   "owner_id": "696d525746e3cc5dc884fd9a",
   "vehicle_type": "passenger_car",
   "make": "HYUNDAI",
   "model": "Ioniq",
   "model_year": "2017",
   "raw_vpic": {
     "ABS": "Standard",
     "ActiveSafetySysNote": "",
     "AdaptiveCruiseControl": "Standard",
     "AdaptiveDrivingBeam": "",
     "AdaptiveHeadlights": "",
     "AdditionalErrorText": "",
     "AirBagLocCurtain": "1st and 2nd Rows",
     "AirBagLocFront": "1st Row (Driver and Passenger)",
     "AirBagLocKnee": "Driver Seat Only",
     "AirBagLocSeatCushion": "",
     "AirBagLocSide": "1st Row (Driver and Passenger)",
     "AutoReverseSystem": "Standard",
     "AutomaticPedestrianAlertingSound": "Standard",
     "AxleConfiguration": "",
     "Axles": "2",
     "BasePrice": "23950.00",
     "BatteryA": "",
     "BatteryA_to": "",
     "BatteryCells": "",
     "BatteryInfo": "6.5(Ah)+Traction Motor [3-phase AC]: 32kW",
     "BatteryKWh": "",
     "BatteryKWh_to": "",
     "BatteryModules": "",
     "BatteryPacks": "",
     "BatteryType": "Lithium-Ion/Li-Ion",
     "BatteryV": "240",
     "BatteryV_to": "",
     "BedLengthIN": "",
     "BedType": "Not Applicable",
     "BlindSpotIntervention": "",
     "BlindSpotMon": "Standard",
     "BodyCabType": "Not Applicable",
     "BodyClass": "Hatchback/Liftback/Notchback",
     "BrakeSystemDesc": "",
     "BrakeSystemType": "",
     "BusFloorConfigType": "Not Applicable",
     "BusLength": "",
     "BusType": "Not Applicable",
     "CAN_AACN": "",
     "CIB": "Standard",
     "CashForClunkers": "",
     "ChargerLevel": "",
     "ChargerPowerKW": "",
     "CombinedBrakingSystem": "",
     "CoolingType": "",
     "CurbWeightLB": "",
     "CustomMotorcycleType": "Not Applicable",
     "DaytimeRunningLight": "Standard",
     "DestinationMarket": "",
     "DisplacementCC": "1600.0",
     "DisplacementCI": "97.63799055157",
     "DisplacementL": "1.6",
     "Doors": "5",
     "DriveType": "",
     "DriverAssist": "",
     "DynamicBrakeSupport": "Standard",
     "EDR": "",
     "ESC": "Standard",
     "EVDriveUnit": "",
     "ElectrificationLevel": "Strong HEV (Hybrid Electric Vehicle)",
     "EngineConfiguration": "",
     "EngineCycles": "",
     "EngineCylinders": "4",
     "EngineHP": "104",
     "EngineHP_to": "",
     "EngineKW": "",
     "EngineManufacturer": "HMC",
     "EngineModel": "GDI KAPPA",
     "EntertainmentSystem": "",
     "ErrorCode": "0",
     "ErrorText": "0 - VIN decoded clean. Check Digit (9th position) is correct",
     "ForwardCollisionWarning": "",
     "FuelInjectionType": "",
     "FuelTankMaterial": "",
     "FuelTankType": "",
     "FuelTypePrimary": "Gasoline",
     "FuelTypeSecondary": "Electric",
     "GCWR": "",
     "GCWR_to": "",
     "GVWR": "Class 1: 6,000 lb or less (2,722 kg or less)",
     "GVWR_to": "Class 1: 6,000 lb or less (2,722 kg or less)",
     "KeylessIgnition": "Standard",
     "LaneCenteringAssistance": "",
     "LaneDepartureWarning": "Standard",
     "LaneKeepSystem": "",
     "LowerBeamHeadlampLightSource": "",
     "Make": "HYUNDAI",
     "MakeID": "498",
     "Manufacturer": "HYUNDAI MOTOR CO",
     "ManufacturerId": "15984",
     "Model": "Ioniq",
     "ModelID": "21961",
     "ModelYear": "2017",
     "MotorcycleChassisType": "Not Applicable",
     "MotorcycleSuspensionType": "Not Applicable",
     "NCSABodyType": "",
     "NCSAMake": "",
     "NCSAMapExcApprovedBy": "",
     "NCSAMapExcApprovedOn": "",
     "NCSAMappingException": "",
     "NCSAModel": "",
     "NCSANote": "",
     "NonLandUse": "",
     "Note": "",
     "OtherBusInfo": "",
     "OtherEngineInfo": "",
     "OtherMotorcycleInfo": "",
     "OtherRestraintSystemInfo": "",
     "OtherTrailerInfo": "",
     "ParkAssist": "",
     "PedestrianAutomaticEmergencyBraking": "",
     "PlantCity": "ULSAN",
     "PlantCompanyName": "Hyundai",
     "PlantCountry": "SOUTH KOREA",
     "PlantState": "",
     "PossibleValues": "",
     "Pretensioner": "",
     "RearAutomaticEmergencyBraking": "",
     "RearCrossTrafficAlert": "",
     "RearVisibilitySystem": "Standard",
     "SAEAutomationLevel": "",
     "SAEAutomationLevel_to": "",
     "SeatBeltsAll": "Manual",
     "SeatRows": "2",
     "Seats": "5",
     "SemiautomaticHeadlampBeamSwitching": "Standard",
     "Series": "",
     "Series2": "Hybrid Vehicle",
     "SteeringLocation": "Left-Hand Drive (LHD)",
     "SuggestedVIN": "",
     "TPMS": "Direct",
     "TopSpeedMPH": "",
     "TrackWidth": "",
     "TractionControl": "Standard",
     "TrailerBodyType": "Not Applicable",
     "TrailerLength": "",
     "TrailerType": "Not Applicable",
     "TransmissionSpeeds": "",
     "TransmissionStyle": "",
     "Trim": "SEL",
     "Trim2": "",
     "Turbo": "",
     "VIN": "KMHC85LCXHU026758",
     "ValveTrainDesign": "Dual Overhead Cam (DOHC)",
     "VehicleDescriptor": "KMHC85LC*HU",
     "VehicleType": "PASSENGER CAR",
     "WheelBaseLong": "",
     "WheelBaseShort": "106.30",
     "WheelBaseType": "",
     "WheelSizeFront": "15",
     "WheelSizeRear": "15",
     "WheelieMitigation": "",
     "Wheels": "4",
     "Windows": ""
   },
   "requires_manual_entry": false,
   "created_at": "2026-01-23T14:29:23.486387",
   "updated_at": null,
   "year": 2017,
   "engine": "1.6L GDI KAPPA",
   "fuel_type": "Gasoline",
   "transmission": "",
   "status": "active",
   "country_code": "JO"
 }
 */
