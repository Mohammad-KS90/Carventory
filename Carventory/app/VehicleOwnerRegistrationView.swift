//
//  VehicleOwnerRegistrationView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI
import VisionKit

struct VehicleOwnerRegistrationView: View {

    @EnvironmentObject var appState: AppState

    @State private var vin = ""
    @State private var isLoading = false
    @State private var error: String?
    @State private var showingVINScanner = false

    // MARK: - Validation

    private var isVINValid: Bool {

        let normalizedVIN = vin
            .uppercased()
            .filter {
                $0.isLetter || $0.isNumber
            }

        guard normalizedVIN.count == 17 else {
            return false
        }

        // VINs do not contain I, O or Q.
        return !normalizedVIN.contains("I")
            && !normalizedVIN.contains("O")
            && !normalizedVIN.contains("Q")
    }

    private var canRegister: Bool {

        !appState.tempUsername
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty &&

        !appState.tempEmail
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty &&

        !appState.tempPassword.isEmpty &&

        !appState.tempFullName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty &&

        !appState.tempPhone
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty &&

        isVINValid
    }

    // MARK: - Body

    var body: some View {

        GeometryReader { geometry in

            let horizontalPadding: CGFloat =
                geometry.size.width >= 768 ? 40 : 20

            let contentWidth = min(
                geometry.size.width - (horizontalPadding * 2),
                560
            )

            ScrollView {

                VStack(spacing: 28) {

                    // MARK: Header

                    headerView(
                        contentWidth: contentWidth,
                        isPad: geometry.size.width >= 768
                    )

                    // MARK: Account

                    accountInformationView(
                        contentWidth: contentWidth
                    )

                    // MARK: Vehicle

                    vehicleInformationView(
                        contentWidth: contentWidth
                    )

                    // MARK: Ownership

                    ownershipInformationView(
                        contentWidth: contentWidth
                    )

                    // MARK: Error

                    if let error {

                        Text(error)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: contentWidth)
                    }

                    // MARK: Register Button

                    Button(action: registerUser) {

                        HStack(spacing: 10) {

                            if isLoading {

                                ProgressView()
                                    .tint(.white)
                            }

                            Text(
                                isLoading
                                ? "Creating Account..."
                                : "Register & Assign Vehicle"
                            )
                        }
                        .frame(
                            maxWidth: 360,
                            minHeight: 55
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canRegister || isLoading)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, horizontalPadding)
                .padding(
                    .vertical,
                    geometry.size.width >= 768 ? 50 : 30
                )
            }
            .scrollIndicators(.hidden)
        }
        .sheet(isPresented: $showingVINScanner) {

            VINScannerView { scannedVIN in

                vin = scannedVIN
                error = nil
            }
        }
    }

    // MARK: - Header

    private func headerView(
        contentWidth: CGFloat,
        isPad: Bool
    ) -> some View {

        VStack(spacing: 10) {

            HStack {
                Image(
                    systemName:
                        "person.crop.circle.badge.plus"
                )
                .font(
                    .system(
                        size: isPad ? 30 : 30
                    )
                )
                .foregroundStyle(.tint)

                Text("Create Your Account")
                    .font(
                        .system(
                            size: isPad ? 30 : 30,
                            weight: .bold
                        )
                    )
                    .multilineTextAlignment(.center)

            }
            Text("""
            Create your Carventory account and \
            connect your vehicle to it.
            """)
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: contentWidth)
        }
    }

    // MARK: - Account Information

    private func accountInformationView(
        contentWidth: CGFloat
    ) -> some View {

        VStack(alignment: .leading, spacing: 16) {

            Label(
                "Account Information",
                systemImage: "person.fill"
            )
            .font(.headline)

            // Username

            formField(
                title: "Username",
                icon: "person.fill"
            ) {

                TextField(
                    "Choose a username",
                    text: $appState.tempUsername
                )
                .textFieldStyle(.roundedBorder)
                .frame(height: 55)
                .font(.system(size: 20))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.username)
                .onChange(
                    of: appState.tempUsername
                ) {
                    _, _ in
                    error = nil
                }
            }

            // Full Name

            formField(
                title: "Full Name",
                icon: "person.text.rectangle.fill"
            ) {

                TextField(
                    "Enter your full name",
                    text: $appState.tempFullName
                )
                .textFieldStyle(.roundedBorder)
                .frame(height: 55)
                .font(.system(size: 20))
                .textContentType(.name)
                .onChange(
                    of: appState.tempFullName
                ) {
                    _, _ in
                    error = nil
                }
            }

            // Email

            formField(
                title: "Email",
                icon: "envelope.fill"
            ) {

                TextField(
                    "Enter your email",
                    text: $appState.tempEmail
                )
                .textFieldStyle(.roundedBorder)
                .frame(height: 55)
                .font(.system(size: 20))
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)
                .onChange(
                    of: appState.tempEmail
                ) {
                    _, _ in
                    error = nil
                }
            }

            // Phone

            formField(
                title: "Phone",
                icon: "phone.fill"
            ) {

                TextField(
                    "Enter your phone number",
                    text: $appState.tempPhone
                )
                .textFieldStyle(.roundedBorder)
                .frame(height: 55)
                .font(.system(size: 20))
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .onChange(
                    of: appState.tempPhone
                ) {
                    _, _ in
                    error = nil
                }
            }

            // Password

            formField(
                title: "Password",
                icon: "lock.fill"
            ) {

                SecureField(
                    "Create a password",
                    text: $appState.tempPassword
                )
                .textFieldStyle(.roundedBorder)
                .frame(height: 55)
                .font(.system(size: 20))
                .textContentType(.newPassword)
                .onChange(
                    of: appState.tempPassword
                ) {
                    _, _ in
                    error = nil
                }
            }

        }
        .frame(
            maxWidth: contentWidth,
            alignment: .leading
        )
    }

    // MARK: - Vehicle Information

    private func vehicleInformationView(
        contentWidth: CGFloat
    ) -> some View {

        VStack(alignment: .leading, spacing: 16) {

            Label(
                "Your Vehicle",
                systemImage: "car.side.fill"
            )
            .font(.headline)

            Text("""
            Enter the VIN of the vehicle you own.
            You can type it manually or scan it using your camera.
            """)
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HStack(spacing: 12) {

                TextField(
                    "Enter VIN",
                    text: $vin
                )
                .textFieldStyle(.roundedBorder)
                .frame(height: 65)
                .font(
                    .system(
                        size: 22,
                        weight: .medium
                    )
                )
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .keyboardType(.asciiCapable)
                .onChange(
                    of: vin
                ) { _, newValue in

                    vin = newValue
                        .uppercased()
                        .filter {
                            $0.isASCII &&
                            ($0.isLetter || $0.isNumber)
                        }
                        .prefix(17)
                        .description

                    error = nil
                }

                Button {

                    openVINScanner()

                } label: {

                    Image(
                        systemName:
                            "camera.viewfinder"
                    )
                    .font(.system(size: 25))
                    .frame(
                        width: 65,
                        height: 65
                    )
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    !DataScannerViewController.isSupported
                )
            }

            HStack {

                Text("VIN")

                Spacer()

                Text("\(vin.count) / 17")
                    .foregroundStyle(
                        isVINValid
                        ? .green
                        : .secondary
                    )
            }
            .font(.caption)

            Text("""
            The VIN must be 17 characters and should match \
            the VIN shown on your vehicle.
            """)
            .font(.caption)
            .foregroundStyle(.secondary)

        }
        .padding(18)
        .frame(
            maxWidth: contentWidth,
            alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color(.secondarySystemBackground)
                )
        )
    }

    // MARK: - Ownership Information

    private func ownershipInformationView(
        contentWidth: CGFloat
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Label(
                "Connect Your Vehicle",
                systemImage: "link.circle.fill"
            )
            .font(.headline)

            Text("""
            When registration is completed, this vehicle will be \
            assigned to your Carventory account.
            """)
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HStack(
                alignment: .top,
                spacing: 10
            ) {

                Image(
                    systemName:
                        "checkmark.shield.fill"
                )
                .foregroundStyle(.tint)

                Text("""
                Make sure the VIN belongs to your own vehicle \
                before continuing.
                """)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            }

            HStack(
                alignment: .top,
                spacing: 10
            ) {

                Image(
                    systemName:
                        "envelope.fill"
                )
                .foregroundStyle(.tint)

                Text("""
                Your vehicle will be connected to the email and \
                phone number registered with this account.
                """)
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
                    Color(.secondarySystemBackground)
                )
        )
    }

    // MARK: - Form Field

    @ViewBuilder
    private func formField<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            Label(
                title,
                systemImage: icon
            )
            .font(.subheadline)
            .fontWeight(.medium)

            content()
        }
    }

    // MARK: - Scanner

    private func openVINScanner() {

        guard DataScannerViewController.isSupported else {

            error =
                "VIN scanning is not supported on this device."

            return
        }

        guard DataScannerViewController.isAvailable else {

            error =
                "Camera scanning is currently unavailable."

            return
        }

        showingVINScanner = true
    }

    // MARK: - Register

    private func registerUser() {
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
