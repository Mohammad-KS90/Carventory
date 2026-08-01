//
//  ScanVIN.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI
struct ScanVINView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var vin = ""
    let countryCode = Locale.current.region?.identifier ?? "JO"

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Your Vehicle").font(.title)

            TextField("VIN Number", text: $vin)
                .textInputAutocapitalization(.characters)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)

            Button("Confirm Vehicle") {
                
                Task {
                    let vehicle = try await VehicleAPI.assignVehicle(vin: vin,
                                                                     countryCode: Locale.current.region?.identifier ?? "JO",
                                                                     userId: appState.user!.id,
                                                                     token: appState.authToken ?? "")
                    appState.vehicle = vehicle
                }
            }
            .disabled(!vin.isEmpty && vin.count != 17)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
