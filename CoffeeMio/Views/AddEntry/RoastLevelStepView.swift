//
//  RoastLevelStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct RoastLevelStepView: View {
    @Binding var roastLevel: RoastLevel?
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

            // Animated coffee beans display
            if let selectedRoastLevel = roastLevel {
                CoffeeBeanRoastDisplay(roastLevel: selectedRoastLevel)
                    .frame(height: 180)
            } else {
                Spacer()
                    .frame(height: 180)
            }

            // Roast level selector
            VStack(spacing: 12) {
                ForEach(RoastLevel.allCases, id: \.self) { level in
                    RoastLevelSelector(
                        level: level,
                        isSelected: roastLevel == level
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            roastLevel = level
                        }
                        showCheckmark = true

                        // Haptic feedback
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()

                        // Auto-advance after brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
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

// MARK: - Coffee Bean Roast Display

struct CoffeeBeanRoastDisplay: View {
    let roastLevel: RoastLevel

    var beanColor: Color {
        switch roastLevel {
        case .light: return Color(hex: "D2B48C")
        case .medium: return Color(hex: "8B4513")
        case .mediumDark: return Color(hex: "654321")
        case .dark: return Color(hex: "3E2723")
        }
    }

    var body: some View {
        // Coffee beans
        HStack(spacing: 12) {
            ForEach(0..<4, id: \.self) { index in
                CoffeeBeanShape()
                    .fill(
                        LinearGradient(
                            colors: [beanColor, beanColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 45, height: 60)
                    .rotationEffect(.degrees(Double.random(in: -15...15)))
                    .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: roastLevel)
    }
}

// MARK: - Coffee Bean Shape

struct CoffeeBeanShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Left curve (bean shape)
        path.move(to: CGPoint(x: width * 0.5, y: 0))

        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.5),
            control1: CGPoint(x: width * 0.2, y: height * 0.1),
            control2: CGPoint(x: 0, y: height * 0.3)
        )

        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control1: CGPoint(x: 0, y: height * 0.7),
            control2: CGPoint(x: width * 0.2, y: height * 0.9)
        )

        // Right curve
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.5),
            control1: CGPoint(x: width * 0.8, y: height * 0.9),
            control2: CGPoint(x: width, y: height * 0.7)
        )

        path.addCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control1: CGPoint(x: width, y: height * 0.3),
            control2: CGPoint(x: width * 0.8, y: height * 0.1)
        )

        // Center line (bean characteristic)
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.2))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.8),
            control: CGPoint(x: width * 0.3, y: height * 0.5)
        )

        return path
    }
}

// MARK: - Roast Level Selector

struct RoastLevelSelector: View {
    let level: RoastLevel
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Level indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(roastColor)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? Color(hex: "FFD700") : Color.clear, lineWidth: 2)
                )

            Text(level.rawValue)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(hex: "FFD700"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(isSelected ? Color(hex: "FFD700").opacity(0.1) : Theme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color(hex: "FFD700") : Color.clear, lineWidth: 2)
        )
    }

    var roastColor: Color {
        switch level {
        case .light: return Color(hex: "D2B48C")
        case .medium: return Color(hex: "8B4513")
        case .mediumDark: return Color(hex: "654321")
        case .dark: return Color(hex: "3E2723")
        }
    }
}
