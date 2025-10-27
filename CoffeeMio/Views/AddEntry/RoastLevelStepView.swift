//
//  RoastLevelStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct RoastLevelStepView: View {
    @Binding var roastLevel: RoastLevel
    let onNext: () -> Void

    @State private var showCheckmark = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("What's the\nroast level?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Roast level options
            VStack(spacing: 16) {
                ForEach(RoastLevel.allCases, id: \.self) { level in
                    RoastLevelCard(
                        level: level,
                        isSelected: roastLevel == level,
                        showCheckmark: showCheckmark && roastLevel == level
                    )
                    .onTapGesture {
                        roastLevel = level
                        showCheckmark = true

                        // Haptic feedback
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()

                        // Auto-advance after brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            onNext()
                        }
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }
}

struct RoastLevelCard: View {
    let level: RoastLevel
    let isSelected: Bool
    let showCheckmark: Bool

    var roastColor: Color {
        switch level {
        case .light: return Color(hex: "C8A882")
        case .medium: return Color(hex: "8B6F47")
        case .mediumDark: return Color(hex: "5D4037")
        case .dark: return Color(hex: "3E2723")
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            // Color indicator
            Circle()
                .fill(roastColor)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Theme.warmOrange : Color.clear, lineWidth: 3)
                )

            Text(level.rawValue)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)

            Spacer()

            if showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Theme.warmOrange)
                    .scaleEffect(showCheckmark ? 1.0 : 0.5)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showCheckmark)
            }
        }
        .padding(20)
        .background(isSelected ? Theme.warmOrange.opacity(0.1) : Theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Theme.warmOrange : Color.clear, lineWidth: 2)
        )
    }
}
