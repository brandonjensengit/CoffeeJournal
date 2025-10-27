//
//  Theme.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct Theme {
    // MARK: - Dynamic Colors (Light/Dark Mode)

    // Primary Coffee Browns
    static let primaryBrown: Color = Color(
        light: Color(hex: "6F4E37"),
        dark: Color(hex: "D4A574")
    )

    static let darkBrown: Color = Color(
        light: Color(hex: "3E2723"),
        dark: Color(hex: "C19A6B")
    )

    // Warm Creams/Backgrounds
    static let cream: Color = Color(
        light: Color(hex: "F5E6D3"),
        dark: Color(hex: "2C1810")
    )

    static let lightCream: Color = Color(
        light: Color(hex: "E4D5C7"),
        dark: Color(hex: "3E2723")
    )

    // Warm Accents (same in both modes for consistency)
    static let warmOrange: Color = Color(hex: "D4A574")
    static let goldenBrown: Color = Color(hex: "C19A6B")

    // Semantic Colors
    static let background: Color = Color(
        light: Color(hex: "FBF7F4"),
        dark: Color(hex: "1A0F0A")  // Deep espresso brown
    )

    static let cardBackground: Color = Color(
        light: .white,
        dark: Color(hex: "2C1810")  // Rich dark brown
    )

    static let textPrimary: Color = Color(
        light: Color(hex: "2C1810"),
        dark: Color(hex: "F5E6D3")  // Warm cream text
    )

    static let textSecondary: Color = Color(
        light: Color(hex: "8B7355"),
        dark: Color(hex: "B09880")  // Lighter brown for contrast
    )

    // Roast Level Colors (brightened slightly for dark mode)
    static let roastLight: Color = Color(
        light: Color(hex: "C8A882"),
        dark: Color(hex: "D4B896")
    )

    static let roastMedium: Color = Color(
        light: Color(hex: "8B6F47"),
        dark: Color(hex: "A68A5F")
    )

    static let roastMediumDark: Color = Color(
        light: Color(hex: "5D4037"),
        dark: Color(hex: "8B6F47")
    )

    static let roastDark: Color = Color(
        light: Color(hex: "3E2723"),
        dark: Color(hex: "6F4E37")
    )

    // MARK: - Gradients
    static func warmGradient(for colorScheme: ColorScheme) -> LinearGradient {
        LinearGradient(
            colors: [warmOrange, goldenBrown],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func coffeeGradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [Color(hex: "3E2723"), Color(hex: "2C1810")],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                colors: [Color(hex: "6F4E37"), Color(hex: "3E2723")],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Shadows
    static func cardShadow(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark
            ? Color.black.opacity(0.4)
            : Color.black.opacity(0.08)
    }

    // MARK: - Corner Radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16
    static let cornerRadiusXL: CGFloat = 20

    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32
}

// MARK: - Color Extension
extension Color {
    // Hex color initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // Dynamic color for light/dark mode
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}
