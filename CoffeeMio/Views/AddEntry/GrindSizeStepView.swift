//
//  GrindSizeStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct GrindSizeStepView: View {
    @Binding var grindSize: Double
    let onNext: () -> Void

    var grindLabel: String {
        switch grindSize {
        case 1.0..<3.0: return "Extra Fine"
        case 3.0..<5.0: return "Fine"
        case 5.0..<7.0: return "Medium"
        case 7.0..<9.0: return "Coarse"
        default: return "Extra Coarse"
        }
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("How fine did you\ngrind it?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            VStack(spacing: 24) {
                // Visual indicator
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.warmOrange, Theme.goldenBrown],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text(grindLabel)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    )

                // Slider
                VStack(spacing: 12) {
                    Slider(value: $grindSize, in: 1...10, step: 0.5)
                        .tint(Theme.warmOrange)

                    HStack {
                        Text("Fine")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                        Spacer()
                        Text("Coarse")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            // Next button
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Theme.primaryBrown)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}
