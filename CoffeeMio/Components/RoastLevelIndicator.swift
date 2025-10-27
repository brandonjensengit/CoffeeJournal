//
//  RoastLevelIndicator.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct RoastLevelIndicator: View {
    @Binding var selectedLevel: RoastLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ForEach(RoastLevel.allCases, id: \.self) { level in
                    RoastLevelButton(
                        level: level,
                        isSelected: selectedLevel == level
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            selectedLevel = level
                        }
                    }
                }
            }

            // Visual gradient bar showing roast progression
            HStack(spacing: 4) {
                ForEach(RoastLevel.allCases, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(roastColor(for: level))
                        .frame(height: 8)
                }
            }
        }
    }

    private func roastColor(for level: RoastLevel) -> Color {
        switch level {
        case .light: return Theme.roastLight
        case .medium: return Theme.roastMedium
        case .mediumDark: return Theme.roastMediumDark
        case .dark: return Theme.roastDark
        }
    }
}

struct RoastLevelButton: View {
    let level: RoastLevel
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(roastColor)
                .frame(width: 32, height: 32)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Theme.warmOrange : Color.clear, lineWidth: 3)
                )
                .shadow(color: isSelected ? Theme.warmOrange.opacity(0.4) : Color.clear, radius: 8)

            Text(level.rawValue)
                .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? Theme.textPrimary : Theme.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }

    private var roastColor: Color {
        switch level {
        case .light: return Theme.roastLight
        case .medium: return Theme.roastMedium
        case .mediumDark: return Theme.roastMediumDark
        case .dark: return Theme.roastDark
        }
    }
}

#Preview {
    VStack {
        RoastLevelIndicator(selectedLevel: .constant(.medium))
            .padding()
    }
    .background(Theme.background)
}
