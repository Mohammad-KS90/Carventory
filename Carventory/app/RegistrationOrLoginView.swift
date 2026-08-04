//
//  RegistrationOrLoginView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI

import SwiftUI

struct RegistrationOrLoginView: View {

    @State private var showRegister = true

    var body: some View {

        GeometryReader { geometry in

            let isPad = geometry.size.width >= 768

            VStack(spacing: 0) {

                // MARK: - Header

                authenticationHeader(
                    isPad: isPad
                )

                // MARK: - Content

                Group {

                    if showRegister {

                        VehicleOwnerRegistrationView()

                    } else {

                        LoginView()
                    }
                }
                .id(showRegister)

                Spacer(minLength: 0)
                // MARK: - Switch

                Picker(
                    "Authentication",
                    selection: $showRegister
                ) {

                    Text("Register")
                        .tag(true)

                    Text("Login")
                        .tag(false)
                }
                .pickerStyle(.segmented)
                .frame(
                    maxWidth: isPad ? 420 : .infinity
                )
                .padding(.horizontal, isPad ? 40 : 20)
                .padding(.top, 20)
                .padding(.bottom, 10)

            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .animation(
                .easeInOut(duration: 0.25),
                value: showRegister
            )
        }
    }

    // MARK: - Header

    private func authenticationHeader(
        isPad: Bool
    ) -> some View {

        VStack(spacing: 8) {

            Image(
                systemName: "car.side.fill"
            )
            .font(
                .system(
                    size: isPad ? 48 : 40
                )
            )
            .foregroundStyle(.tint)

            Text("Carventory")
                .font(
                    .system(
                        size: isPad ? 30 : 26,
                        weight: .bold
                    )
                )

            Text(
                showRegister
                ? "Create your account and add your vehicle"
                : "Sign in to manage your vehicles"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(.top, isPad ? 30 : 20)
        .padding(.horizontal, 20)
    }
}
