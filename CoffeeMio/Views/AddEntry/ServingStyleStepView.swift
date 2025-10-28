//
//  ServingStyleStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct ServingStyleStepView: View {
    @Binding var servingStyle: ServingStyle?
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("Hot or Iced?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Serving style cards
            VStack(spacing: 16) {
                // Hot card
                ServingStyleCard(
                    style: .hot,
                    isSelected: servingStyle == .hot
                )
                .onTapGesture {
                    handleSelection(.hot)
                }

                // Iced card
                ServingStyleCard(
                    style: .iced,
                    isSelected: servingStyle == .iced
                )
                .onTapGesture {
                    handleSelection(.iced)
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }

    private func handleSelection(_ style: ServingStyle) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            servingStyle = style
        }

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        // Auto-advance after brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            onNext()
        }
    }
}

// MARK: - Serving Style Card

struct ServingStyleCard: View {
    let style: ServingStyle
    let isSelected: Bool

    @State private var showSteam = false

    var cardColors: (start: Color, end: Color) {
        switch style {
        case .hot:
            return (Color(hex: "8B6F47"), Color(hex: "A0826D"))
        case .iced:
            return (Color(hex: "7A6550"), Color(hex: "8B7355"))
        }
    }

    var iconColor: Color {
        switch style {
        case .hot:
            return Color(hex: "FFD7A8") // Warm cream
        case .iced:
            return Color(hex: "87CEEB").opacity(0.8) // Light blue
        }
    }

    var body: some View {
        ZStack {
            // Card background
            LinearGradient(
                colors: [cardColors.start, cardColors.end],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(hex: "FFD700") : Color.clear, lineWidth: 3)
            )

            HStack(spacing: 20) {
                // Icon with optional steam
                ZStack {
                    if style == .hot && showSteam {
                        SteamWisps()
                            .offset(y: -25)
                    }

                    Image(systemName: style.icon)
                        .font(.system(size: 48))
                        .foregroundStyle(iconColor)
                }
                .frame(width: 70)

                // Text
                Text(style.rawValue)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color(hex: "FFD700"))
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 120)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        .onAppear {
            if style == .hot {
                // Start steam animation for hot option
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showSteam = true
                }
            }
        }
    }
}

// MARK: - Steam Wisps for Hot Icon

struct SteamWisps: View {
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                SteamWisp(delay: Double(index) * 0.3, xOffset: CGFloat(index - 1) * 8)
                    .id("serving-steam-\(index)")
            }
        }
    }
}

struct SteamWisp: View {
    @Environment(\.colorScheme) private var colorScheme
    let delay: Double
    let xOffset: CGFloat
    @State private var yOffset: Double = 0
    @State private var opacity: Double = 0
    @State private var hasStartedAnimating = false

    var body: some View {
        Capsule()
            .fill(Color.white.opacity(0.6))
            .frame(width: 3, height: 15)
            .blur(radius: 2)
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                guard !hasStartedAnimating else { return }
                hasStartedAnimating = true

                withAnimation(
                    .easeOut(duration: 2.0)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    yOffset = -40
                    opacity = 0
                }

                withAnimation(
                    .easeIn(duration: 0.3)
                    .delay(delay)
                ) {
                    opacity = 0.6
                }
            }
    }
}
