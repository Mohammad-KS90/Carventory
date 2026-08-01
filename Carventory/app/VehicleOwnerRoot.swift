//
//  VehicleOwnerRoot.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI

struct VehicleOwnerRoot: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.vehicle == nil {
            AssignVehicleView()
        } else {
            VehicleOwnerDashboardView()
        }
    }
}
