//
//  WaterTempStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct WaterTempStepView: View {
    @Binding var waterTemp: Double
    let onNext: () -> Void

    @State private var temperatureManager = TemperatureManager.shared

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("How hot is\nthe water?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            VStack(spacing: 24) {
                // Temperature display
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Image(systemName: "thermometer")
                        .font(.system(size: 40))
                        .foregroundStyle(Theme.warmOrange)

                    Text("\(Int(waterTemp))")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.primaryBrown)

                    Text(temperatureManager.selectedUnit.symbol)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }

                // Slider
                Slider(value: $waterTemp, in: temperatureManager.sliderRange(), step: 1)
                    .tint(Theme.warmOrange)
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
