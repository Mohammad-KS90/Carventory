//
//  RootView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            if !appState.isLoggedIn {
                RegistrationOrLoginView()
            } else {
                switch appState.domain {
                case .owner:
                    Text("Owner App")
//                    VehicleOwnerRoot()
                case .admin:
                    Text("Admin App")
                case .vehicleOwner:
                    VehicleOwnerRoot()
                case .serviceCenter:
                    Text("Service Center App")
                case .pos:
                    Text("POS App")
                case .support:
                    Text("Support App")
                case .driver:
                    Text("Driver App")
                case .system:
                    Text("System App")
                case .none:
                    Text("No domain assigned")
                }
            }
        }.padding(.all, 0)
    }
}
