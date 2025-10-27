//
//  WaterTempStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct WaterTempStepView: View {
    @Binding var waterTemp: Double
    let onNext: () -> Void

    @State private var temperatureManager = TemperatureManager.shared
    @Environment(\.colorScheme) private var colorScheme

    // Computed properties for temperature-based effects
    var temperatureInCelsius: Double {
        temperatureManager.toCelsius(waterTemp)
    }

    var frostCoverage: Double {
        let temp = temperatureInCelsius
        if temp >= 65 { return 0 }
        if temp >= 60 { return 0.1 }
        if temp >= 50 { return 0.25 }
        return 0.45
    }

    var bubblingIntensity: Int {
        let temp = temperatureInCelsius
        if temp < 90 { return 0 }
        if temp < 94 { return 3 }
        if temp < 97 { return 5 }
        return 8
    }

    var backgroundGradient: LinearGradient {
        let temp = temperatureInCelsius
        let colors: [Color]

        if temp < 65 {
            // Cold: Cooler brown with gray undertones
            colors = [Color(hex: "7A6550"), Color(hex: "8B7355")]
        } else if temp < 90 {
            // Medium: Classic warm coffee brown
            colors = [Color(hex: "8B6F47"), Color(hex: "A0826D")]
        } else {
            // Hot: Rich warm brown with amber tones
            colors = [Color(hex: "6F4E37"), Color(hex: "B8926A")]
        }

        return LinearGradient(
            colors: colorScheme == .dark ? colors.map { $0.opacity(0.4) } : colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack {
            // Dynamic background gradient
            backgroundGradient
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.6), value: temperatureInCelsius)

            // Cold temperature frost effects
            if temperatureInCelsius < 65 {
                FrostCrystalEffect(coverage: frostCoverage)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.2), value: temperatureInCelsius)
            }

            // Hot temperature bubbling effects
            if temperatureInCelsius > 90 {
                CoffeeBubblingEffect(intensity: bubblingIntensity)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.2), value: temperatureInCelsius)
            }

            VStack(spacing: 40) {
                Spacer()

                // Question
                Text("How hot is\nthe water?")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryBrown)
                    .multilineTextAlignment(.center)

                // Animated thermometer with steam
                ZStack {
                    // Steam wisps above thermometer
                    TemperatureSteam(temperature: temperatureInCelsius)
                        .offset(y: -80)

                    // Animated thermometer
                    AnimatedThermometer(temperature: temperatureInCelsius)

                }
                .frame(height: 200)

                // Temperature display
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(waterTemp))")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.primaryBrown)

                    Text(temperatureManager.selectedUnit.symbol)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }

                // Slider
                Slider(value: $waterTemp, in: temperatureManager.sliderRange(), step: 1)
                    .tint(Theme.warmOrange)
                    .padding(.horizontal, 32)

                Spacer()

                // Next button
                Button(action: onNext) {
                    Text("Next")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Theme.primaryBrown)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }
}

// MARK: - Animated Thermometer

struct AnimatedThermometer: View {
    let temperature: Double
    @Environment(\.colorScheme) private var colorScheme

    // Temperature range: 70-100°C
    var fillPercentage: Double {
        min(max((temperature - 70) / 30, 0), 1)
    }

    var mercuryColor: Color {
        let temp = temperature
        if temp < 80 {
            return Color(hex: "78909C") // Cool gray
        } else if temp < 90 {
            return Color(hex: "FF9800") // Warm orange
        } else {
            return Color(hex: "F44336") // Hot red
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Thermometer tube (background)
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.5))
                    .frame(width: 30, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )

                // Mercury column (animated fill)
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [mercuryColor, mercuryColor.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 30, height: 120 * fillPercentage)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: fillPercentage)

                // Thermometer bulb at bottom
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [mercuryColor, mercuryColor.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .offset(y: 22)
                    .shadow(color: mercuryColor.opacity(0.4), radius: 8, y: 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 60, height: 160)
    }
}

// MARK: - Temperature Steam

struct TemperatureSteam: View {
    let temperature: Double
    @Environment(\.colorScheme) private var colorScheme

    var steamConfig: (count: Int, baseOpacity: Double) {
        let temp = temperature
        if temp < 65 {
            return (5, 0.35) // Cold - visible but subtle
        } else if temp < 90 {
            return (6, 0.45) // Medium - more prominent
        } else {
            return (7, 0.55) // Hot - very prominent
        }
    }

    var body: some View {
        ZStack {
            ForEach(0..<steamConfig.count, id: \.self) { index in
                TemperatureSteamWisp(
                    index: index,
                    totalCount: steamConfig.count,
                    baseOpacity: steamConfig.baseOpacity
                )
                .id("steam-\(index)-\(steamConfig.count)")
            }
        }
    }
}

struct TemperatureSteamWisp: View {
    @Environment(\.colorScheme) private var colorScheme
    let index: Int
    let totalCount: Int
    let baseOpacity: Double

    // Animation state
    @State private var yOffset: Double = 0
    @State private var xOffset: Double = 0
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.3
    @State private var rotation: Double = 0
    @State private var hasStartedAnimating = false

    // Random variations for natural look
    let initialXOffset: Double
    let duration: Double
    let maxSway: Double
    let rotationAmount: Double
    let wispWidth: CGFloat
    let wispHeight: CGFloat
    let blurRadius: CGFloat

    init(index: Int, totalCount: Int, baseOpacity: Double) {
        self.index = index
        self.totalCount = totalCount
        self.baseOpacity = baseOpacity

        // Generate random variations for natural appearance
        self.initialXOffset = Double.random(in: -15...15)
        self.duration = Double.random(in: 3.5...5.0)
        self.maxSway = Double.random(in: 15...25)
        self.rotationAmount = Double.random(in: -10...10)
        self.wispWidth = CGFloat.random(in: 12...20) // Larger
        self.wispHeight = CGFloat.random(in: 30...50) // Taller
        self.blurRadius = CGFloat.random(in: 10...15)
    }

    var steamColor: Color {
        // Make steam darker and more visible in light mode
        colorScheme == .dark ? Color.white : Color.gray
    }

    var body: some View {
        // Organic wispy shape
        WispShape()
            .fill(
                LinearGradient(
                    colors: [
                        steamColor.opacity(1.0),
                        steamColor.opacity(0.6),
                        steamColor.opacity(0.0)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: wispWidth, height: wispHeight)
            .blur(radius: blurRadius)
            .shadow(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.3), radius: 3)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                guard !hasStartedAnimating else { return }
                hasStartedAnimating = true

                let delay = Double(index) * 0.5

                // Rising motion with ease-out
                withAnimation(
                    .easeOut(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    yOffset = -80
                    opacity = 0
                    scale = 2.0 // Expand as it rises
                }

                // Horizontal sway with sine wave
                withAnimation(
                    .easeInOut(duration: duration * 0.6)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    xOffset = initialXOffset + maxSway
                }

                // Rotation
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    rotation = rotationAmount
                }

                // Initial fade in
                withAnimation(
                    .easeIn(duration: 0.5)
                    .delay(delay)
                ) {
                    opacity = baseOpacity
                }
            }
    }
}

// MARK: - Coffee Bubbling Effect

struct CoffeeBubblingEffect: View {
    let intensity: Int

    var body: some View {
        ZStack {
            ForEach(0..<intensity, id: \.self) { index in
                CoffeeBubble(index: index)
                    .id("coffee-bubble-\(index)-\(intensity)")
            }
        }
    }
}

struct CoffeeBubble: View {
    let index: Int
    @State private var yOffset: Double = 0
    @State private var xOffset: Double = 0
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.6
    @State private var hasStartedAnimating = false

    let bubbleSize: CGFloat
    let duration: Double
    let delay: Double
    let wobbleAmount: Double

    init(index: Int) {
        self.index = index
        self.bubbleSize = CGFloat.random(in: 8...20)
        self.duration = Double.random(in: 3.0...4.0)
        self.delay = Double.random(in: 0...2.0)
        self.wobbleAmount = Double.random(in: -15...15)
    }

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: "D4A574").opacity(0.8),
                        Color(hex: "C8B08A").opacity(0.6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: bubbleSize, height: bubbleSize)
            .blur(radius: 4)
            .scaleEffect(scale)
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                guard !hasStartedAnimating else { return }
                hasStartedAnimating = true

                // Random X starting position
                xOffset = Double.random(in: -120...120)
                yOffset = 180 // Start from bottom

                // Rising animation
                withAnimation(
                    .easeOut(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    yOffset = -150
                    opacity = 0
                    scale = 1.0
                }

                // Wobble animation
                withAnimation(
                    .easeInOut(duration: duration * 0.6)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    xOffset += wobbleAmount
                }

                // Initial fade in
                withAnimation(
                    .easeIn(duration: 0.4)
                    .delay(delay)
                ) {
                    opacity = 0.7
                }
            }
    }
}

// MARK: - Frost Crystal Effect

struct FrostCrystalEffect: View {
    let coverage: Double
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Top left corner frost
                FrostCluster(size: geometry.size.width * coverage * 0.6)
                    .position(x: 0, y: 0)

                // Top right corner frost
                FrostCluster(size: geometry.size.width * coverage * 0.5)
                    .position(x: geometry.size.width, y: 0)

                // Bottom left corner frost
                FrostCluster(size: geometry.size.width * coverage * 0.4)
                    .position(x: 0, y: geometry.size.height)

                // Bottom right corner frost
                FrostCluster(size: geometry.size.width * coverage * 0.4)
                    .position(x: geometry.size.width, y: geometry.size.height)

                // Additional scattered crystals for medium/high coverage
                if coverage > 0.2 {
                    ForEach(0..<5, id: \.self) { index in
                        FrostCrystal(size: CGFloat.random(in: 20...40))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .opacity(Double.random(in: 0.3...0.5))
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct FrostCluster: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                FrostCrystal(size: size * CGFloat.random(in: 0.6...1.0))
                    .rotationEffect(.degrees(Double(index) * 45))
                    .offset(
                        x: CGFloat.random(in: -20...20),
                        y: CGFloat.random(in: -20...20)
                    )
            }
        }
        .opacity(0.4)
    }
}

struct FrostCrystal: View {
    let size: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    var frostColor: Color {
        colorScheme == .dark
            ? Color(hex: "E3F2FD")
            : Color(hex: "B3E5FC")
    }

    var body: some View {
        ZStack {
            // Center
            Circle()
                .fill(frostColor)
                .frame(width: size * 0.3, height: size * 0.3)

            // Six points (snowflake pattern)
            ForEach(0..<6, id: \.self) { index in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [frostColor, frostColor.opacity(0.0)],
                            startPoint: .center,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: size, height: size * 0.1)
                    .rotationEffect(.degrees(Double(index) * 60))
            }

            // Secondary branches
            ForEach(0..<6, id: \.self) { index in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [frostColor.opacity(0.7), frostColor.opacity(0.0)],
                            startPoint: .center,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: size * 0.6, height: size * 0.06)
                    .offset(x: size * 0.2)
                    .rotationEffect(.degrees(Double(index) * 60 + 30))
            }
        }
        .blur(radius: 2)
    }
}
