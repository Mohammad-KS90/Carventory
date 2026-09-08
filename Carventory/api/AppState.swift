//
//  AppState.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var authToken: String?
    @Published var isLoggedIn = false
    @Published var user: User?
    @Published var vehicle: Vehicle?

    // Temporary registration info
    @Published var tempUsername: String = "mohammad"
    @Published var tempEmail: String = "mohammad@gmail.com"
    @Published var tempPassword: String = "xikqet-xEzmy0-seffiq"
    @Published var tempFullName: String = "mohammad mohammad"
    @Published var tempPhone: String = "+962788949581"
    @Published var languageCode: String = "JO"
    
    
    var domain: AppDomain? {
        guard let roles = user?.role else { return nil }
        return DomainResolver.resolve(roles: [roles])
    }
    
    func logout() {
        user = nil
        vehicle = nil
        isLoggedIn = false
        // clear token/session...
    }

}
