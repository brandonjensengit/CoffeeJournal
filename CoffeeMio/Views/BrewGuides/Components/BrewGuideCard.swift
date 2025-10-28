//
//  BrewGuideCard.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/28/25.
//

import SwiftUI

struct BrewGuideCard: View {
    let guide: BrewGuide
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Theme.warmOrange.opacity(0.1))
                    .frame(width: 60, height: 60)

                Image(systemName: guide.heroImage)
                    .font(.system(size: 28))
                    .foregroundStyle(Theme.warmOrange)
            }
            .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 6) {
                // Name
                Text(guide.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Theme.primaryBrown)
                    .lineLimit(1)

                // Description
                Text(guide.shortDescription)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                // Stats row
                HStack(spacing: 8) {
                    // Difficulty badge
                    DifficultyBadge(difficulty: guide.difficulty)

                    Spacer()

                    // Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.textSecondary)

                        Text(guide.brewTimeRange)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .frame(height: 200)
        .background(Theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Theme.cardShadow(for: colorScheme), radius: 4, y: 2)
    }
}

// MARK: - Difficulty Badge

struct DifficultyBadge: View {
    let difficulty: Difficulty

    private var badgeColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(badgeColor)
                .frame(width: 6, height: 6)

            Text(difficulty.rawValue)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(badgeColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.15))
        .cornerRadius(8)
    }
}

#Preview {
    BrewGuideCard(guide: BrewGuideProvider.shared.allGuides[0])
        .padding()
}
