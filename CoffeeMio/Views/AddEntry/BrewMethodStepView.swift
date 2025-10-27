//
//  BrewMethodStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct BrewMethodStepView: View {
    @Binding var brewMethod: BrewMethod?
    let onNext: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @State private var showCheckmark = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("How are you\nbrewing it?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Brew method grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(BrewMethod.allCases, id: \.self) { method in
                    BrewMethodCard(
                        method: method,
                        isSelected: brewMethod == method,
                        showCheckmark: showCheckmark && brewMethod == method
                    )
                    .onTapGesture {
                        brewMethod = method
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
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}

struct BrewMethodCard: View {
    let method: BrewMethod
    let isSelected: Bool
    let showCheckmark: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isSelected ? Theme.warmOrange : Theme.cardBackground)
                    .frame(width: 70, height: 70)

                Image(systemName: method.icon)
                    .font(.system(size: 30))
                    .foregroundStyle(isSelected ? .white : Theme.primaryBrown)

                if showCheckmark {
                    Circle()
                        .fill(Theme.warmOrange)
                        .frame(width: 70, height: 70)

                    Image(systemName: "checkmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .scaleEffect(showCheckmark ? 1.0 : 0.5)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showCheckmark)
                }
            }

            Text(method.rawValue)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(8)
        .background(isSelected ? Theme.cream.opacity(0.3) : Color.clear)
        .cornerRadius(12)
    }
}
