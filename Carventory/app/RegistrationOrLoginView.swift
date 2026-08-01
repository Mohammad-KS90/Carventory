//
//  RegistrationOrLoginView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI

struct RegistrationOrLoginView: View {
    @State private var showRegister = true

    var body: some View {
        VStack(spacing: 16) {

            if showRegister {
                VehicleOwnerRegistrationView()
            } else {
                LoginView()
            }
            
            Picker("", selection: $showRegister) {
                Text("Register").tag(true)
                Text("Login").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 20)

        }
    }
}
