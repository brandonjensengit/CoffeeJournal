//
//  BrewTimeStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct BrewTimeStepView: View {
    @Binding var brewMinutes: Int
    @Binding var brewSeconds: Int
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("How long are we\nbrewing it?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Time display
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.warmOrange)

                Text("\(brewMinutes)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryBrown)

                Text("m")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)

                Text("\(brewSeconds)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryBrown)

                Text("s")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
            }

            // Pickers
            HStack(spacing: 20) {
                // Minutes
                VStack(spacing: 8) {
                    Text("Minutes")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)

                    Picker("Minutes", selection: $brewMinutes) {
                        ForEach(0...10, id: \.self) { minute in
                            Text("\(minute)").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100, height: 150)
                }

                // Seconds
                VStack(spacing: 8) {
                    Text("Seconds")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)

                    Picker("Seconds", selection: $brewSeconds) {
                        ForEach(0...59, id: \.self) { second in
                            Text("\(second)").tag(second)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100, height: 150)
                }
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
