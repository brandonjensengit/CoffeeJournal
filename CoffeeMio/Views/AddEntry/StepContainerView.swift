//
//  StepContainerView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct StepContainerView<Content: View>: View {
    let currentStep: CoffeeEntryStep
    let canGoBack: Bool
    let canSkip: Bool
    let onBack: () -> Void
    let onSkip: () -> Void
    @ViewBuilder let content: Content

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            VStack(spacing: 12) {
                // Step indicator
                HStack {
                    if canGoBack {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Theme.primaryBrown)
                        }
                    }

                    Spacer()

                    Text("Step \(currentStep.stepNumber) of \(currentStep.totalSteps)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)

                    Spacer()

                    if canSkip {
                        Button(action: onSkip) {
                            Text("Skip")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    } else {
                        // Invisible spacer to balance layout
                        Text("Skip")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.clear)
                    }
                }
                .padding(.horizontal, 20)

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.cream)
                            .frame(height: 6)

                        // Progress
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Theme.warmOrange, Theme.goldenBrown],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * currentStep.progress, height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 20)
            }
            .padding(.top, 16)
            .padding(.bottom, 24)

            // Content area
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            LinearGradient(
                colors: [
                    colorScheme == .dark ? Theme.background : Theme.cream.opacity(0.3),
                    colorScheme == .dark ? Theme.background : Theme.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
