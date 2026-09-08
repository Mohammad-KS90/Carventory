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
    let full_name: String?
    let country_code: String
    let vehicle_id: String?
    var role: String = "VehicleOwner"
    var account_type: String = "individual"
    let status: String?
    let company_id: String?
    let branch_id: String?
    
}

enum VehicleOwnerAPI {
    static func createUser(payload: VehicleOwnerCreateRequest) async throws -> User {
        let body = try JSONEncoder().encode(payload)
        let headers:[String:String] = ["Content-Type" : "application/json", "Accept": "application/json"]
            return try await APIClient.request(
            path: "/IAM/vehicle-owner",
            method: "POST",
            body: body,
            headers: headers
        )
    }

    static func getMe(token: String) async throws -> User {
        
        return try await APIClient.request(
            path: "/IAM/vehicle-owner/me",
            token: token
        )
    }
}
