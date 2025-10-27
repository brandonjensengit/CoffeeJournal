//
//  RoastWordBeanTitle.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct RoastWordBeanTitle: View {
    let selectedRoastLevel: RoastLevel?

    @State private var beanColor: Color = Color(hex: "A8C686") // Start green (unroasted)
    @State private var showSmoke: Bool = false

    var targetColor: Color {
        guard let level = selectedRoastLevel else {
            return Color(hex: "A8C686") // Green
        }

        switch level {
        case .light: return Color(hex: "D2B48C")
        case .medium: return Color(hex: "8B4513")
        case .mediumDark: return Color(hex: "654321")
        case .dark: return Color(hex: "3E2723")
        }
    }

    var smokeIntensity: Int {
        guard let level = selectedRoastLevel else { return 0 }

        switch level {
        case .light: return 2
        case .medium: return 3
        case .mediumDark: return 4
        case .dark: return 5
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            // "What's the"
            Text("What's the")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)

            // Dense bean pile with ROAST text cutout
            ZStack {
                // Smoke effect during roasting
                if showSmoke {
                    RoastingSmokeEffect(intensity: smokeIntensity)
                        .transition(.opacity)
                }

                // Dense bean pile masked by "ROAST" text
                DenseBeanPile(beanColor: beanColor)
                    .frame(width: 240, height: 70)
                    .mask(
                        Text("ROAST")
                            .font(.system(size: 52, weight: .black))
                    )
            }
            .frame(height: 90) // Extra space for smoke

            // "level?"
            Text("level?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
        }
        .onChange(of: selectedRoastLevel) { oldValue, newValue in
            if newValue != nil {
                // Start roasting animation
                withAnimation(.easeInOut(duration: 1.8)) {
                    beanColor = targetColor
                }

                // Start smoke after 0.5s delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        showSmoke = true
                    }
                }
            } else {
                // Reset to green
                beanColor = Color(hex: "A8C686")
                showSmoke = false
            }
        }
    }
}

// MARK: - Dense Bean Pile

struct DenseBeanPile: View {
    let beanColor: Color

    // Pre-defined bean positions for consistent, dense coverage
    let beanPositions: [(x: CGFloat, y: CGFloat, rotation: Double)] = [
        // Row 1 (top)
        (-90, -20, -25), (-60, -22, 15), (-30, -18, -10), (0, -20, 20), (30, -22, -15), (60, -18, 10), (90, -20, -20),
        // Row 2 (middle-top)
        (-100, -5, 30), (-70, -8, -20), (-40, -5, 25), (-10, -8, -15), (20, -5, 18), (50, -8, -25), (80, -5, 12), (100, -8, -18),
        // Row 3 (middle)
        (-90, 10, -18), (-60, 8, 22), (-30, 10, -12), (0, 8, 28), (30, 10, -22), (60, 8, 15), (90, 10, -28),
        // Row 4 (middle-bottom)
        (-100, 22, 20), (-70, 25, -15), (-40, 22, 10), (-10, 25, -25), (20, 22, 16), (50, 25, -20), (80, 22, 25), (100, 25, -10),
        // Row 5 (bottom)
        (-90, 38, -22), (-60, 35, 18), (-30, 38, -16), (0, 35, 24), (30, 38, -14), (60, 35, 20), (90, 38, -26)
    ]

    var body: some View {
        ZStack {
            ForEach(Array(beanPositions.enumerated()), id: \.offset) { index, position in
                CoffeeBeanShape()
                    .fill(
                        LinearGradient(
                            colors: [beanColor, beanColor.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 32)
                    .rotationEffect(.degrees(position.rotation))
                    .offset(x: position.x, y: position.y)
                    .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
            }
        }
    }
}

// MARK: - Roasting Smoke Effect

struct RoastingSmokeEffect: View {
    let intensity: Int

    var body: some View {
        ZStack {
            ForEach(0..<intensity, id: \.self) { index in
                RoastingSmokeWisp(index: index, totalCount: intensity)
                    .id("roast-title-smoke-\(index)-\(intensity)")
            }
        }
        .offset(y: -20) // Rise from text
    }
}

struct RoastingSmokeWisp: View {
    let index: Int
    let totalCount: Int

    @State private var yOffset: Double = 0
    @State private var xOffset: Double = 0
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.3
    @State private var hasStartedAnimating = false

    let duration: Double
    let delay: Double

    init(index: Int, totalCount: Int) {
        self.index = index
        self.totalCount = totalCount
        self.duration = Double.random(in: 3.0...4.5)
        self.delay = Double(index) * 0.3
    }

    var body: some View {
        WispShape()
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.4),
                        Color.gray.opacity(0.2),
                        Color.gray.opacity(0.0)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 12, height: 28)
            .blur(radius: 6)
            .scaleEffect(scale)
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                guard !hasStartedAnimating else { return }
                hasStartedAnimating = true

                // Spread smoke across the width of "ROAST" text
                xOffset = Double.random(in: -100...100)

                withAnimation(
                    .easeOut(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    yOffset = -50
                    opacity = 0
                    scale = 1.2
                }

                withAnimation(
                    .easeIn(duration: 0.4)
                    .delay(delay)
                ) {
                    opacity = 0.3
                }
            }
    }
}
