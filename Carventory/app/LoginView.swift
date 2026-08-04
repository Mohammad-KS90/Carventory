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

    private var canLogin: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }

    var body: some View {

        GeometryReader { geometry in

            let horizontalPadding: CGFloat =
                geometry.size.width >= 768 ? 40 : 20

            let contentWidth = min(
                geometry.size.width - (horizontalPadding * 2),
                520
            )

            ScrollView {

                VStack(spacing: 28) {

                    // MARK: - Header

                    VStack(spacing: 10) {

                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                .font(
                                    .system(
                                        size: geometry.size.width >= 768
                                        ? 56
                                        : 48
                                    )
                                )
                                .foregroundStyle(.tint)

                            Text("Welcome Back")
                                .font(
                                    .system(
                                        size: geometry.size.width >= 768
                                        ? 36
                                        : 32,
                                        weight: .bold
                                    )
                                )
                                .multilineTextAlignment(.center)

                        }
                        Text("""
                        Sign in to your Carventory account
                        to manage your vehicles and services.
                        """)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: contentWidth)
                    }

                    // MARK: - Login Form

                    VStack(spacing: 16) {

                        // Email

                        VStack(alignment: .leading, spacing: 8) {

                            Label(
                                "Email",
                                systemImage: "envelope.fill"
                            )
                            .font(.subheadline)
                            .fontWeight(.medium)

                            TextField(
                                "Enter your email",
                                text: $email
                            )
                            .textFieldStyle(.roundedBorder)
                            .frame(height: 55)
                            .font(.system(size: 20))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.username)
                            .onChange(of: email) { _, _ in
                                error = nil
                            }
                        }

                        // Password

                        VStack(alignment: .leading, spacing: 8) {

                            Label(
                                "Password",
                                systemImage: "lock.fill"
                            )
                            .font(.subheadline)
                            .fontWeight(.medium)

                            SecureField(
                                "Enter your password",
                                text: $password
                            )
                            .textFieldStyle(.roundedBorder)
                            .frame(height: 55)
                            .font(.system(size: 20))
                            .textContentType(.password)
                            .onChange(of: password) { _, _ in
                                error = nil
                            }
                        }
                    }
                    .frame(maxWidth: contentWidth)

                    // MARK: - Account Information

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            "Your account, your vehicles",
                            systemImage: "person.crop.circle.fill"
                        )
                        .font(.headline)

                        Text("""
                        After signing in, Carventory will load your account \
                        and the vehicles assigned to you.
                        """)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )

                        HStack(
                            alignment: .top,
                            spacing: 10
                        ) {

                            Image(
                                systemName: "shield.checkered"
                            )
                            .foregroundStyle(.tint)

                            Text(
                                "Your vehicles are linked to your registered account."
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                        }

                    }
                    .padding(18)
                    .frame(
                        maxWidth: contentWidth,
                        alignment: .leading
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                Color(
                                    .secondarySystemBackground
                                )
                            )
                    )

                    // MARK: - Error

                    if let error {

                        Text(error)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .frame(
                                maxWidth: contentWidth
                            )
                    }

                    // MARK: - Login Button

                    Button(action: login) {

                        HStack(spacing: 10) {

                            if isLoading {

                                ProgressView()
                                    .tint(.white)
                            }

                            Text(
                                isLoading
                                ? "Signing In..."
                                : "Sign In"
                            )
                        }
                        .frame(
                            maxWidth: 300,
                            minHeight: 55
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canLogin || isLoading)
                }
                .frame(
                    maxWidth: .infinity
                )
                .padding(.horizontal, horizontalPadding)
                .padding(
                    .vertical,
                    geometry.size.width >= 768 ? 50 : 30
                )
            }
            .scrollIndicators(.hidden)
        }
    }

    // MARK: - Login

    private func login() {
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
