//
//  RatingStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct RatingStepView: View {
    @Binding var rating: Double
    let onNext: () -> Void

    @State private var showEncouragement = false
    @State private var tappedStar: Int? = nil
    @State private var showConfetti = false

    var encouragementMessage: String {
        switch rating {
        case 5.0: return "Excellent choice! ✨"
        case 4.0...4.9: return "Great!"
        case 3.0...3.9: return "Good choice!"
        case 2.0...2.9: return "Not bad!"
        default: return "Thanks for rating!"
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                Spacer()

                // Question
                Text("How was it?")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryBrown)
                    .multilineTextAlignment(.center)

                // Stars
                ZStack {
                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { star in
                            AnimatedStar(
                                starNumber: star,
                                isSelected: star <= Int(rating),
                                isTapped: tappedStar == star
                            )
                            .onTapGesture {
                                handleStarTap(star)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }

                // Encouragement message
                if showEncouragement {
                    Text(encouragementMessage)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(hex: "FFD700"))
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showEncouragement)
                }

                Spacer()
            }

            // Confetti celebration for 5 stars
            if showConfetti {
                ConfettiEffect()
                    .transition(.opacity)
            }
        }
    }

    private func handleStarTap(_ star: Int) {
        rating = Double(star)
        tappedStar = star
        showEncouragement = true

        // Reset tapped star after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tappedStar = nil
        }

        // Haptic feedback
        if star == 5 {
            // Celebration haptic for 5 stars
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

            // Show confetti
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showConfetti = false
            }
        } else {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }

        // Auto-advance after showing encouragement
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            onNext()
        }
    }
}

// MARK: - Animated Star

struct AnimatedStar: View {
    let starNumber: Int
    let isSelected: Bool
    let isTapped: Bool

    @State private var sparkle = false

    var body: some View {
        ZStack {
            // Golden glow for selected stars
            if isSelected {
                Image(systemName: "star.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color(hex: "FFD700").opacity(0.3))
                    .blur(radius: 8)
                    .scaleEffect(1.5)
            }

            // Main star
            Image(systemName: isSelected ? "star.fill" : "star")
                .font(.system(size: 44))
                .foregroundStyle(
                    isSelected ?
                    LinearGradient(
                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [Theme.textSecondary.opacity(0.3), Theme.textSecondary.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(isTapped ? 1.2 : (isSelected ? 1.05 : 1.0))
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isTapped)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)

            // Sparkle effect on tap
            if isTapped {
                SparkleEffect()
            }
        }
    }
}

// MARK: - Sparkle Effect

struct SparkleEffect: View {
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                Image(systemName: "sparkle")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "FFD700"))
                    .offset(x: cos(Double(index) * .pi / 2) * 25,
                           y: sin(Double(index) * .pi / 2) * 25)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                opacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                opacity = 0
            }
        }
    }
}

// MARK: - Confetti Effect

struct ConfettiEffect: View {
    var body: some View {
        ZStack {
            ForEach(0..<30, id: \.self) { index in
                ConfettiParticle(index: index)
            }
        }
    }
}

struct ConfettiParticle: View {
    let index: Int
    @State private var yOffset: CGFloat = 0
    @State private var xOffset: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1

    let colors = ["FFD700", "FFA500", "8B4513", "D2691E", "FFEFD5"]
    let shapes = ["circle.fill", "star.fill", "heart.fill"]

    var particleColor: Color {
        Color(hex: colors.randomElement() ?? "FFD700")
    }

    var particleShape: String {
        shapes.randomElement() ?? "circle.fill"
    }

    var body: some View {
        Image(systemName: particleShape)
            .font(.system(size: CGFloat.random(in: 8...16)))
            .foregroundStyle(particleColor)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                let angle = Double.random(in: 0...(2 * .pi))
                let velocity = CGFloat.random(in: 80...150)
                let finalX = cos(angle) * velocity
                let finalY = sin(angle) * velocity * 0.6

                withAnimation(.easeOut(duration: 1.5)) {
                    xOffset = finalX
                    yOffset = finalY + 200 // Gravity effect
                    rotation = Double.random(in: 0...720)
                    opacity = 0
                    scale = 0.5
                }
            }
    }
}
