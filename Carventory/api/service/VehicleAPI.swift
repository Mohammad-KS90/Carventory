//
//  VehicleAPI.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import Foundation

struct AssignVehicleRequest: Encodable {
    let vin: String
    let country_code: String
    let user_id: String?
}

enum VehicleAPI {
    static func assignVehicle(vin: String, countryCode: String, userId: String, token: String) async throws -> Vehicle {
        
        let body = ["vin": vin, "country_code": countryCode, "user_id": userId]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let headers = ["Content-Type": "application/json"]
        
        do {
            return try await APIClient.request(
                path: "/vehicles/assign",
                method: "POST",
                body: bodyData,
                headers: headers,
                token: token
            )
        } catch {
            let vehicle = try VINManager.shared.vehicle(from: vin)
            // call api and assign the vehicle to the user
            
            return vehicle
        }
    }

    static func getMyVehicles(token: String) async throws -> [Vehicle] {
        return try await APIClient.request(
            path: "/vehicles/my",
            token: token
        )
    }
}


