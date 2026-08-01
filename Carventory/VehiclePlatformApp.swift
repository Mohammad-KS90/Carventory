//
//  VehiclePlatformApp.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI

@main
struct VehicleOwnerApp: App {
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
