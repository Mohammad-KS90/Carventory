//
//  LoginView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = "mohmmadOwner@gmail.com"
    @State private var password = "Mohmmadkhaleel@100"
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Login").font(.title)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let error = error {
                Text(error).foregroundColor(.red)
            }

            Button(action: login) {
                if isLoading { ProgressView() }
                else { Text("Login") }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    func login() {
        Task {
            isLoading = true
            error = nil
            do {
                let token = try await AuthAPI.login(email: email, password: password)
                appState.authToken = token
                appState.isLoggedIn = true

                let user = try await VehicleOwnerAPI.getMe(token: token)
                appState.user = user
//
                let vehicles = try await VehicleAPI.getMyVehicles(token: token)
                appState.vehicle = vehicles.first
                appState.languageCode = Locale.current.language.languageCode?.identifier ?? "en"
            
            } catch let e {
                error = e.localizedDescription
            }
            isLoading = false
        }
    }
}
