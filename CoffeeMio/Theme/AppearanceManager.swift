//
//  AppearanceManager.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

enum AppearanceMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"

    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "circle.lefthalf.filled"
        }
    }
}

@Observable
class AppearanceManager {
    static let shared = AppearanceManager()

    var selectedMode: AppearanceMode {
        didSet {
            UserDefaults.standard.set(selectedMode.rawValue, forKey: "appearance_mode")
            applyAppearance()
        }
    }

    private init() {
        // Load saved preference or default to system
        let savedMode = UserDefaults.standard.string(forKey: "appearance_mode") ?? AppearanceMode.system.rawValue
        self.selectedMode = AppearanceMode(rawValue: savedMode) ?? .system
    }

    func applyAppearance() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        for window in windowScene.windows {
            switch selectedMode {
            case .light:
                window.overrideUserInterfaceStyle = .light
            case .dark:
                window.overrideUserInterfaceStyle = .dark
            case .system:
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }

    func colorScheme(for mode: AppearanceMode) -> ColorScheme? {
        switch mode {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
