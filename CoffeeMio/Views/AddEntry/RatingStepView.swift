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

    var encouragementMessage: String {
        switch rating {
        case 5.0: return "Outstanding! ✨"
        case 4.0...4.9: return "Excellent!"
        case 3.0...3.9: return "Great choice!"
        case 2.0...2.9: return "Not bad!"
        default: return "Thanks for logging!"
        }
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("How was it?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Stars
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        rating = Double(star)
                        showEncouragement = true

                        // Haptic feedback
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()

                        // Auto-advance after showing encouragement
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            onNext()
                        }
                    }) {
                        Image(systemName: star <= Int(rating) ? "star.fill" : "star")
                            .font(.system(size: 44))
                            .foregroundStyle(
                                star <= Int(rating) ?
                                LinearGradient(
                                    colors: [Theme.warmOrange, Theme.goldenBrown],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Theme.textSecondary.opacity(0.3), Theme.textSecondary.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(star <= Int(rating) ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rating)
                    }
                }
            }
            .padding(.horizontal, 40)

            // Encouragement message
            if showEncouragement {
                Text(encouragementMessage)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.warmOrange)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showEncouragement)
            }

            Spacer()
        }
    }
}
