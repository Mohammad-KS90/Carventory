//
//  AssignVehicleView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 24/01/2026.
//


import SwiftUI

struct AssignVehicleView: View {
    @EnvironmentObject var appState: AppState
    @State private var vin = "KMHC85LCXHU026758"
    @State private var error: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Assign Your Vehicle")
                .font(.title)
                .padding(.all, 15)
            
            TextField("VIN", text: $vin)
                .textFieldStyle(.roundedBorder)
                .frame(width: 500, height: 70)
                .font(Font.system(size: 30))
                .multilineTextAlignment(.center)

            if let error = error {
                Text(error).foregroundColor(.red)
            }

            Button("Assign Vehicle") {
                Task {
                    do {
                        let vehicle = try await VehicleAPI.assignVehicle(vin: vin,
                                                                         countryCode: Locale.current.region?.identifier ?? "JO",
                                                                         userId: appState.user!.id,
                                                                         token: appState.authToken ?? "")
                        appState.vehicle = vehicle
                    } catch {
                        self.error = error.localizedDescription
                    }
                }
            }
        }
        .padding(.all, 100)
    }
}
