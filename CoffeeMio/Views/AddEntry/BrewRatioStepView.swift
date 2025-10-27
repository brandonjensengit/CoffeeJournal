//
//  BrewRatioStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct BrewRatioStepView: View {
    @Binding var coffeeGrams: Double
    @Binding var waterGrams: Double
    let onNext: () -> Void

    @FocusState private var focusedField: Field?

    enum Field {
        case coffee, water
    }

    var brewRatio: String {
        let ratio = waterGrams / coffeeGrams
        return "1:\(String(format: "%.1f", ratio))"
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("What's your\nbrew ratio?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Ratio display
            Text(brewRatio)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.warmOrange)

            // Input fields
            VStack(spacing: 20) {
                // Coffee
                VStack(alignment: .leading, spacing: 8) {
                    Text("Coffee")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)

                    HStack {
                        TextField("18", value: $coffeeGrams, format: .number)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .background(Theme.cardBackground)
                            .cornerRadius(12)
                            .focused($focusedField, equals: .coffee)

                        Text("g")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                            .frame(width: 30)
                    }
                }

                // Water
                VStack(alignment: .leading, spacing: 8) {
                    Text("Water")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)

                    HStack {
                        TextField("300", value: $waterGrams, format: .number)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .background(Theme.cardBackground)
                            .cornerRadius(12)
                            .focused($focusedField, equals: .water)

                        Text("g")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                            .frame(width: 30)
                    }
                }
            }
            .padding(.horizontal, 32)

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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
                .foregroundStyle(Theme.primaryBrown)
                .fontWeight(.semibold)
            }
        }
    }
}
