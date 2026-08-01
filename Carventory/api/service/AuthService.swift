//
//  AuthService.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let token_type: String
}

enum AuthAPI {
    static func login(email: String, password: String) async throws -> String {
        let payload = ["username": email, "password": password].percentEncoded()
//        let body = try JSONSerialization.data(withJSONObject: payload)

        let response: AuthResponse = try await APIClient.request(
            path: "/authentication/token",
            method: "POST",
            body: payload
        )
        return response.access_token
    }
}

extension Dictionary where Key == String, Value == String {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(escapedKey)=\(escapedValue)"
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
