//
//  TemperatureManager.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import Foundation
import SwiftUI

enum TemperatureUnit: String, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"

    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }

    var icon: String {
        switch self {
        case .celsius: return "c.circle"
        case .fahrenheit: return "f.circle"
        }
    }
}

@Observable
class TemperatureManager {
    static let shared = TemperatureManager()

    var selectedUnit: TemperatureUnit {
        didSet {
            UserDefaults.standard.set(selectedUnit.rawValue, forKey: "temperature_unit")
        }
    }

    private init() {
        if let savedUnit = UserDefaults.standard.string(forKey: "temperature_unit"),
           let unit = TemperatureUnit(rawValue: savedUnit) {
            self.selectedUnit = unit
        } else {
            self.selectedUnit = .celsius
        }
    }

    // MARK: - Conversion Methods

    func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 9.0 / 5.0) + 32.0
    }

    func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32.0) * 5.0 / 9.0
    }

    // MARK: - Display Helpers

    func displayTemperature(_ celsius: Double) -> String {
        switch selectedUnit {
        case .celsius:
            return "\(Int(celsius))°C"
        case .fahrenheit:
            return "\(Int(celsiusToFahrenheit(celsius)))°F"
        }
    }

    func displayValue(_ celsius: Double) -> Double {
        switch selectedUnit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return celsiusToFahrenheit(celsius)
        }
    }

    func toCelsius(_ value: Double) -> Double {
        switch selectedUnit {
        case .celsius:
            return value
        case .fahrenheit:
            return fahrenheitToCelsius(value)
        }
    }

    // MARK: - Slider Range

    func sliderRange() -> ClosedRange<Double> {
        switch selectedUnit {
        case .celsius:
            return 70...100
        case .fahrenheit:
            return 158...212 // 70°C to 100°C in Fahrenheit
        }
    }

    func defaultTemperature() -> Double {
        switch selectedUnit {
        case .celsius:
            return 93.0
        case .fahrenheit:
            return celsiusToFahrenheit(93.0) // ~199°F
        }
    }
}
