//
//  CoffeeEntry.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import Foundation
import SwiftData

@Model
final class CoffeeEntry {
    var id: UUID
    var coffeeName: String
    var origin: String
    var roaster: String
    var brewMethod: BrewMethod
    var roastLevel: RoastLevel
    var grindSize: Double // 1.0 (fine) to 10.0 (coarse)
    var coffeeGrams: Double
    var waterGrams: Double
    var waterTemperature: Double? // in Celsius (nil for cold brew)
    var brewTimeMinutes: Int
    var brewTimeSeconds: Int
    var rating: Double // 1.0 to 5.0
    var tastingNotes: [String]
    var personalNotes: String
    var dateLogged: Date
    var isFavorite: Bool
    var isIced: Bool // Hot or iced serving
    var photoData: Data?
    var customizations: CoffeeCustomizations?

    init(
        id: UUID = UUID(),
        coffeeName: String = "",
        origin: String = "",
        roaster: String = "",
        brewMethod: BrewMethod = .pourOver,
        roastLevel: RoastLevel = .medium,
        grindSize: Double = 5.0,
        coffeeGrams: Double = 18.0,
        waterGrams: Double = 300.0,
        waterTemperature: Double? = 93.0,
        brewTimeMinutes: Int = 3,
        brewTimeSeconds: Int = 0,
        rating: Double = 3.0,
        tastingNotes: [String] = [],
        personalNotes: String = "",
        dateLogged: Date = Date(),
        isFavorite: Bool = false,
        isIced: Bool = false,
        photoData: Data? = nil,
        customizations: CoffeeCustomizations? = nil
    ) {
        self.id = id
        self.coffeeName = coffeeName
        self.origin = origin
        self.roaster = roaster
        self.brewMethod = brewMethod
        self.roastLevel = roastLevel
        self.grindSize = grindSize
        self.coffeeGrams = coffeeGrams
        self.waterGrams = waterGrams
        self.waterTemperature = waterTemperature
        self.brewTimeMinutes = brewTimeMinutes
        self.brewTimeSeconds = brewTimeSeconds
        self.rating = rating
        self.tastingNotes = tastingNotes
        self.personalNotes = personalNotes
        self.dateLogged = dateLogged
        self.isFavorite = isFavorite
        self.isIced = isIced
        self.photoData = photoData
        self.customizations = customizations
    }

    var brewRatio: String {
        let ratio = waterGrams / coffeeGrams
        return "1:\(String(format: "%.1f", ratio))"
    }

    var totalBrewTime: String {
        let minutes = brewTimeMinutes
        let seconds = brewTimeSeconds
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

enum BrewMethod: String, Codable, CaseIterable {
    case espresso = "Espresso"
    case pourOver = "Pour Over"
    case frenchPress = "French Press"
    case aeroPress = "AeroPress"
    case coldBrew = "Cold Brew"
    case mokaPot = "Moka Pot"
    case drip = "Drip"
    case siphon = "Siphon"
    case chemex = "Chemex"

    var icon: String {
        switch self {
        case .espresso: return "cup.and.saucer.fill"
        case .pourOver: return "drop.fill"
        case .frenchPress: return "cylinder.fill"
        case .aeroPress: return "arrow.down.circle.fill"
        case .coldBrew: return "snowflake"
        case .mokaPot: return "flame.fill"
        case .drip: return "drop.triangle.fill"
        case .siphon: return "flask.fill"
        case .chemex: return "triangle.fill"
        }
    }
}

enum RoastLevel: String, Codable, CaseIterable {
    case light = "Light"
    case medium = "Medium"
    case mediumDark = "Medium-Dark"
    case dark = "Dark"

    var color: String {
        switch self {
        case .light: return "RoastLight"
        case .medium: return "RoastMedium"
        case .mediumDark: return "RoastMediumDark"
        case .dark: return "RoastDark"
        }
    }
}

enum ServingStyle: String, Codable, CaseIterable {
    case hot = "Hot"
    case iced = "Iced"

    var icon: String {
        switch self {
        case .hot: return "cup.and.saucer.fill"
        case .iced: return "snowflake"
        }
    }
}
