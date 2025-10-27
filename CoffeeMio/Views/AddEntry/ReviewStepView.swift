//
//  ReviewStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct ReviewStepView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var temperatureManager = TemperatureManager.shared

    let coffeeName: String
    let roaster: String
    let brewMethod: BrewMethod?
    let roastLevel: RoastLevel?
    let grindSize: Double
    let coffeeGrams: Double
    let waterGrams: Double
    let waterTemp: Double
    let brewMinutes: Int
    let brewSeconds: Int
    let rating: Double
    let tastingNotes: [String]
    let personalNotes: String
    let selectedImage: UIImage?
    let onSave: () -> Void

    var grindLabel: String {
        switch grindSize {
        case 1.0..<3.0: return "Extra Fine"
        case 3.0..<5.0: return "Fine"
        case 5.0..<7.0: return "Medium"
        case 7.0..<9.0: return "Coarse"
        default: return "Extra Coarse"
        }
    }

    var brewRatio: String {
        let ratio = waterGrams / coffeeGrams
        return "1:\(String(format: "%.1f", ratio))"
    }

    var brewTime: String {
        if brewMinutes > 0 {
            return "\(brewMinutes)m \(brewSeconds)s"
        } else {
            return "\(brewSeconds)s"
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 8) {
                Text("Review Your\nCoffee Log")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryBrown)
                    .multilineTextAlignment(.center)

                Text("Everything look good?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(.top, 16)

            // Summary content in a scroll view
            ScrollView {
                VStack(spacing: 20) {
                    // Photo if available
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(16)
                            .shadow(color: Theme.cardShadow(for: colorScheme), radius: 8, y: 4)
                    }

                    // Coffee Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        // Coffee name and rating
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(coffeeName)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(Theme.primaryBrown)

                                Text(roaster)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Theme.textSecondary)
                            }

                            Spacer()

                            // Rating stars
                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= Int(rating) ? "star.fill" : "star")
                                        .font(.system(size: 20))
                                        .foregroundStyle(Theme.warmOrange)
                                }
                            }
                        }

                        Divider()

                        // Brew method and roast
                        HStack(spacing: 24) {
                            if let brewMethod = brewMethod {
                                DetailItem(icon: brewMethod.icon, label: "Method", value: brewMethod.rawValue)
                            }
                            Spacer()
                            if let roastLevel = roastLevel {
                                DetailItem(icon: "flame.fill", label: "Roast", value: roastLevel.rawValue)
                            }
                        }

                        Divider()

                        // Parameters grid
                        VStack(spacing: 12) {
                            HStack(spacing: 24) {
                                DetailItem(icon: "circle.dotted", label: "Grind", value: grindLabel)
                                Spacer()
                                DetailItem(icon: "scalemass.fill", label: "Ratio", value: brewRatio)
                            }

                            HStack(spacing: 24) {
                                DetailItem(
                                    icon: "thermometer",
                                    label: "Water",
                                    value: temperatureManager.displayTemperature(waterTemp)
                                )
                                Spacer()
                                DetailItem(icon: "clock.fill", label: "Time", value: brewTime)
                            }
                        }

                        // Tasting notes
                        if !tastingNotes.isEmpty {
                            Divider()

                            VStack(alignment: .leading, spacing: 8) {
                                Label("Tasting Notes", systemImage: "sparkles")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.textSecondary)

                                FlowLayout(spacing: 8) {
                                    ForEach(tastingNotes, id: \.self) { note in
                                        Text(note)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(Theme.cream)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(Theme.primaryBrown)
                                            )
                                    }
                                }
                            }
                        }

                        // Personal notes
                        if !personalNotes.isEmpty {
                            Divider()

                            VStack(alignment: .leading, spacing: 8) {
                                Label("Personal Notes", systemImage: "note.text")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.textSecondary)

                                Text(personalNotes)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(Theme.primaryBrown)
                            }
                        }
                    }
                    .padding(20)
                    .background(Theme.cardBackground)
                    .cornerRadius(16)
                    .shadow(color: Theme.cardShadow(for: colorScheme), radius: 8, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }

            // Save button
            Button(action: onSave) {
                Text("Save Entry")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Theme.warmOrange, Theme.goldenBrown],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

// MARK: - Detail Item Component

struct DetailItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.warmOrange)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)

                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.primaryBrown)
            }
        }
    }
}

// Note: FlowLayout is defined in EntryDetailView.swift
