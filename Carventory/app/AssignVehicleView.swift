//
//  AssignVehicleView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 24/01/2026.
//

import SwiftUI
import VisionKit

struct AssignVehicleView: View {

    @EnvironmentObject var appState: AppState

    @State private var vin = "KMHC85LCXHU026758"
    @State private var error: String?
    @State private var showingVINScanner = false
    @State private var isAssigning = false

    private var countryCode: String {
        Locale.current.region?.identifier ?? "JO"
    }

    // MARK: - VIN Validation

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

                    // MARK: VIN Input

                    vinInputView(
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
                            .frame(
                                maxWidth: contentWidth
                            )
                    }

                    // MARK: Assign Button

                    Button {

                        assignVehicle()

                    } label: {

                        HStack(spacing: 10) {

                            if isAssigning {

                                ProgressView()
                                    .tint(.white)
                            }

                            Text(
                                isAssigning
                                ? "Assigning..."
                                : "Assign Vehicle"
                            )
                        }
                        .frame(
                            maxWidth: 300,
                            minHeight: 55
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        !isVINValid ||
                        isAssigning
                    )
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
        .sheet(
            isPresented: $showingVINScanner
        ) {

            VINScannerView { scannedVIN in

                vin = normalizeVIN(scannedVIN)
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

            Image(
                systemName: "car.side.fill"
            )
            .font(
                .system(
                    size: isPad ? 56 : 48
                )
            )
            .foregroundStyle(.tint)

            Text("Assign Your Vehicle")
                .font(
                    .system(
                        size: isPad ? 36 : 32,
                        weight: .bold
                    )
                )
                .multilineTextAlignment(.center)

            Text("""
            Enter or scan the VIN of your own vehicle.
            This vehicle will be assigned to your Carventory account.
            """)
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: contentWidth)
        }
    }

    // MARK: - VIN Input

    private func vinInputView(
        contentWidth: CGFloat
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Label(
                "Vehicle Identification Number",
                systemImage: "number.square.fill"
            )
            .font(.headline)

            Text("""
            Enter the VIN manually or use your camera to scan \
            the VIN from your vehicle.
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
                .onChange(of: vin) { _, newValue in

                    vin = normalizeVIN(newValue)
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
                .accessibilityLabel(
                    "Scan VIN with camera"
                )
            }

            // MARK: VIN Status

            HStack {

                HStack(spacing: 6) {

                    Circle()
                        .fill(
                            isVINValid
                            ? Color.green
                            : Color.secondary
                        )
                        .frame(
                            width: 7,
                            height: 7
                        )

                    Text("VIN")
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(vin.count) / 17")
                    .fontWeight(
                        isVINValid
                        ? .semibold
                        : .regular
                    )
                    .foregroundStyle(
                        isVINValid
                        ? .green
                        : .secondary
                    )
            }
            .font(.caption)

            if isVINValid {

                Label(
                    "VIN format is valid",
                    systemImage: "checkmark.circle.fill"
                )
                .font(.caption)
                .foregroundStyle(.green)

            } else {

                Text("""
                A VIN must contain exactly 17 characters.
                VINs do not contain I, O or Q.
                """)
                .font(.caption)
                .foregroundStyle(.secondary)
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

    // MARK: - Ownership Information

    private func ownershipInformationView(
        contentWidth: CGFloat
    ) -> some View {

        VStack(alignment: .leading, spacing: 14) {

            Label(
                "Confirm Your Vehicle",
                systemImage: "checkmark.shield.fill"
            )
            .font(.headline)

            Text("""
            Before assigning the vehicle, make sure the VIN you entered \
            matches the VIN displayed on your vehicle.
            """)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )

            Divider()

            HStack(
                alignment: .top,
                spacing: 10
            ) {

                Image(
                    systemName:
                        "person.crop.circle.fill"
                )
                .foregroundStyle(.tint)

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("Your Account")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("""
                    This vehicle will be linked to your \
                    registered Carventory account.
                    """)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
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

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("Email & Phone")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("""
                    The vehicle will be associated with the \
                    email and phone number registered to your account.
                    """)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }

            HStack(
                alignment: .top,
                spacing: 10
            ) {

                Image(
                    systemName:
                        "car.fill"
                )
                .foregroundStyle(.tint)

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("Vehicle")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("""
                    The VIN identifies the specific vehicle you \
                    are adding to your account.
                    """)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
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

    // MARK: - VIN Normalization

    private func normalizeVIN(
        _ value: String
    ) -> String {

        value
            .uppercased()
            .filter {
                $0.isASCII &&
                ($0.isLetter || $0.isNumber)
            }
            .prefix(17)
            .description
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

    // MARK: - Assign Vehicle

    
    private func assignVehicle() {
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
    
//    private func assignVehicle() {
//
//        guard isVINValid else {
//
//            error =
//                "Please enter a valid 17-character VIN."
//
//            return
//        }
//
//        guard let user = appState.user else {
//
//            error =
//                "Your account information is not available. Please sign in again."
//
//            return
//        }
//
//        guard let token = appState.authToken,
//              !token.isEmpty else {
//
//            error =
//                "Your session has expired. Please sign in again."
//
//            return
//        }
//
//        isAssigning = true
//        error = nil
//
//        Task {
//
//            do {
//
//                let vehicle =
//                    try await VehicleAPI.assignVehicle(
//                        vin: vin,
//                        countryCode: countryCode,
//                        userId: user.id,
//                        token: token
//                    )
//
//                await MainActor.run {
//
//                    appState.vehicle = vehicle
//                    isAssigning = false
//                }
//
//            } catch {
//
//                await MainActor.run {
//
//                    self.error =
//                        error.localizedDescription
//
//                    self.isAssigning = false
//                }
//            }
//        }
//    }
}
