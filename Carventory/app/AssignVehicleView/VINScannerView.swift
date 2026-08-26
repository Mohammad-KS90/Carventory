//
//  VINScannerView.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 21/02/1448 AH.
//


import SwiftUI
import VisionKit

struct VINScannerView: UIViewControllerRepresentable {

    @Environment(\.dismiss) private var dismiss

    let onVINDetected: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(
            onVINDetected: onVINDetected,
            dismiss: dismiss
        )
    }

    func makeUIViewController(context: Context) -> DataScannerViewController {

        let scanner = DataScannerViewController(
            recognizedDataTypes: [
                .text()
            ],
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )

        scanner.delegate = context.coordinator

        return scanner
    }

    func updateUIViewController(
        _ uiViewController: DataScannerViewController,
        context: Context
    ) {
        if !uiViewController.isScanning {
            try? uiViewController.startScanning()
        }
    }

    static func dismantleUIViewController(
        _ uiViewController: DataScannerViewController,
        coordinator: Coordinator
    ) {
        uiViewController.stopScanning()
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {

        let onVINDetected: (String) -> Void
        let dismiss: DismissAction

        init(
            onVINDetected: @escaping (String) -> Void,
            dismiss: DismissAction
        ) {
            self.onVINDetected = onVINDetected
            self.dismiss = dismiss
        }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didAdd addedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {
            for item in addedItems {

                guard case .text(let text) = item else {
                    continue
                }

                let vin = Self.extractVIN(from: text.transcript)

                guard let vin else {
                    continue
                }

                DispatchQueue.main.async {
                    self.onVINDetected(vin)
                    self.dismiss()
                }

                return
            }
        }

        private static func extractVIN(from text: String) -> String? {

            let normalized = text
                .uppercased()
                .filter { $0.isLetter || $0.isNumber }

            // VINs are exactly 17 characters.
            guard normalized.count == 17 else {
                return nil
            }

            // VINs do not use I, O, or Q.
            let invalidCharacters = CharacterSet(
                charactersIn: "IOQ"
            )

            guard normalized.rangeOfCharacter(
                from: invalidCharacters
            ) == nil else {
                return nil
            }

            guard normalized.allSatisfy({
                $0.isASCII && ($0.isLetter || $0.isNumber)
            }) else {
                return nil
            }

            return normalized
        }
    }
}

