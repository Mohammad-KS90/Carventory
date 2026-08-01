//
//  VehicleOwnerAPI.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import Foundation

struct VehicleOwnerCreateRequest: Codable {
    let username: String
    let email: String
    let password: String
    let phone: String?
    let fullName: String?
    let countryCode: String
    let vehicleId: String?
    let role: String = "VehicleOwner"
    let accountType: String = "individual"
}

enum VehicleOwnerAPI {
    static func createUser(payload: VehicleOwnerCreateRequest) async throws -> User {
        let body = try JSONEncoder().encode(payload)
        return try await APIClient.request(
            path: "/IAM/vehicle-owner",
            method: "POST",
            body: body
        )
    }

    static func getMe(token: String) async throws -> User {
        
        return try await APIClient.request(
            path: "/IAM/vehicle-owner/me",
            token: token
        )
    }
}
