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
    @Published var tempUsername: String = ""
    @Published var tempEmail: String = ""
    @Published var tempPassword: String = ""
    @Published var tempFullName: String = ""
    @Published var tempPhone: String = ""
    @Published var languageCode: String = ""
    
    
    var domain: AppDomain? {
        guard let roles = user?.role else { return nil }
        return DomainResolver.resolve(roles: [roles])
    }

}
