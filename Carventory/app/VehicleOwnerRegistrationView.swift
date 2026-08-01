//
//  VehicleOwnerRegistrationView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI

struct VehicleOwnerRegistrationView: View {
    @EnvironmentObject var appState: AppState
    @State private var vin = ""
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Register VehicleOwner").font(.title)

                TextField("Username", text: $appState.tempUsername)
//                TextField("Username", text: .constant("VehicleOwner"))
                    .textFieldStyle(.roundedBorder)

                TextField("Email", text: $appState.tempEmail)
//                TextField("Email", text: .constant("VehicleOwner@gmail.com"))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $appState.tempPassword)
//                SecureField("Password", text: .constant("VehicleOwner123!"))
                    .textFieldStyle(.roundedBorder)

//                TextField("Full Name", text: .constant("mohammad Vehicle Owner"))
                TextField("Full Name", text: $appState.tempFullName)
                    .textFieldStyle(.roundedBorder)

                TextField("Phone", text: $appState.tempPhone)
//                TextField("Phone", text: .constant("+9627889949581"))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)

                TextField("VIN Number", text: $vin)
//                TextField("VIN Number", text: .constant("KMHC85LCXHU026758"))
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.characters)
                    .disableAutocorrection(true)

                if let error = error {
                    Text(error).foregroundColor(.red)
                }

                Button(action: registerUser) {
                    if isLoading { ProgressView() }
                    else { Text("Register & Assign Vehicle") }
                }
                .disabled(vin.count != 17 || appState.tempEmail.isEmpty || appState.tempPassword.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }

    func registerUser() {
        Task {
            isLoading = true
            error = nil
            do {

                let payload = VehicleOwnerCreateRequest(
                    username: appState.tempUsername,
                    email: appState.tempEmail,
                    password: appState.tempPassword,
                    phone: appState.tempPhone,
                    fullName: appState.tempFullName,
                    countryCode: "JO",
                    vehicleId: nil
                )

                _ = try await VehicleOwnerAPI.createUser(payload: payload)

                let token = try await AuthAPI.login(email: appState.tempEmail, password: appState.tempPassword)
                appState.authToken = token
                appState.isLoggedIn = true

                let user = try await VehicleOwnerAPI.getMe(token: token)
                appState.user = user
                
                let vehicle = try await VehicleAPI.assignVehicle(vin: vin,
                                                                 countryCode: Locale.current.region?.identifier ?? "JO",
                                                                 userId: appState.user!.id, token: appState.authToken ?? "")
                appState.vehicle = vehicle


            } catch let e {
                error = e.localizedDescription
            }
            isLoading = false
        }
    }
}
