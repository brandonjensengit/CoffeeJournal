//
//  Customizations.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/27/25.
//

import Foundation
import SwiftData

// MARK: - Main Customizations Model

@Model
final class CoffeeCustomizations {
    var milk: MilkCustomization?
    var sweeteners: [Sweetener]
    var flavors: [Flavor]
    var spices: [String]
    var hasWhippedCream: Bool
    var iceAmount: IceAmount?

    init(
        milk: MilkCustomization? = nil,
        sweeteners: [Sweetener] = [],
        flavors: [Flavor] = [],
        spices: [String] = [],
        hasWhippedCream: Bool = false,
        iceAmount: IceAmount? = nil
    ) {
        self.milk = milk
        self.sweeteners = sweeteners
        self.flavors = flavors
        self.spices = spices
        self.hasWhippedCream = hasWhippedCream
        self.iceAmount = iceAmount
    }

    var hasAnyCustomizations: Bool {
        milk != nil || !sweeteners.isEmpty || !flavors.isEmpty ||
        !spices.isEmpty || hasWhippedCream || iceAmount != nil
    }
}

// MARK: - Milk Customization

@Model
final class MilkCustomization {
    var type: MilkType
    var amount: String // e.g., "Splash", "1:1", "2oz"
    var temperature: MilkTemperature?
    var foamLevel: FoamLevel?

    init(
        type: MilkType = .whole,
        amount: String = "Splash",
        temperature: MilkTemperature? = nil,
        foamLevel: FoamLevel? = nil
    ) {
        self.type = type
        self.amount = amount
        self.temperature = temperature
        self.foamLevel = foamLevel
    }
}

enum MilkType: String, Codable, CaseIterable {
    case whole = "Whole"
    case twoPercent = "2%"
    case oat = "Oat"
    case almond = "Almond"
    case soy = "Soy"
    case coconut = "Coconut"
    case heavyCream = "Heavy Cream"
    case halfAndHalf = "Half & Half"
}

enum MilkTemperature: String, Codable, CaseIterable {
    case cold = "Cold"
    case roomTemp = "Room Temp"
    case steamed = "Steamed"
    case extraHot = "Extra Hot"
}

enum FoamLevel: String, Codable, CaseIterable {
    case none = "No Foam"
    case light = "Light"
    case medium = "Medium"
    case heavy = "Heavy"
}

// MARK: - Sweetener

@Model
final class Sweetener {
    var type: SweetenerType
    var amount: String // e.g., "1 tsp", "2 pumps"

    init(type: SweetenerType = .sugar, amount: String = "1 tsp") {
        self.type = type
        self.amount = amount
    }
}

enum SweetenerType: String, Codable, CaseIterable {
    case sugar = "Sugar"
    case honey = "Honey"
    case agave = "Agave"
    case stevia = "Stevia"
    case brownSugar = "Brown Sugar"
    case maple = "Maple Syrup"
}

// MARK: - Flavor/Syrup

@Model
final class Flavor {
    var type: FlavorType
    var amount: String // e.g., "1 pump", "2 pumps"

    init(type: FlavorType = .vanilla, amount: String = "1 pump") {
        self.type = type
        self.amount = amount
    }
}

enum FlavorType: String, Codable, CaseIterable {
    case vanilla = "Vanilla"
    case caramel = "Caramel"
    case hazelnut = "Hazelnut"
    case mocha = "Mocha"
    case lavender = "Lavender"
    case cardamom = "Cardamom"
    case seasonal = "Seasonal"
}

// MARK: - Ice Amount

enum IceAmount: String, Codable, CaseIterable {
    case light = "Light Ice"
    case regular = "Regular Ice"
    case extra = "Extra Ice"
}
