//
//  BrewGuide.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/28/25.
//

import Foundation

// MARK: - Brew Guide Model

struct BrewGuide: Identifiable {
    let id: UUID
    let method: BrewMethod
    let name: String
    let shortDescription: String
    let fullDescription: String
    let heroImage: String
    let difficulty: Difficulty
    let brewTimeRange: String
    let quickStats: QuickStats
    let equipment: [EquipmentItem]
    let steps: [BrewGuideStep]
    let tips: [String]
    let troubleshooting: [TroubleshootingItem]
    let servingInfo: ServingInfo

    init(
        id: UUID = UUID(),
        method: BrewMethod,
        name: String,
        shortDescription: String,
        fullDescription: String,
        heroImage: String,
        difficulty: Difficulty,
        brewTimeRange: String,
        quickStats: QuickStats,
        equipment: [EquipmentItem],
        steps: [BrewGuideStep],
        tips: [String],
        troubleshooting: [TroubleshootingItem],
        servingInfo: ServingInfo
    ) {
        self.id = id
        self.method = method
        self.name = name
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.heroImage = heroImage
        self.difficulty = difficulty
        self.brewTimeRange = brewTimeRange
        self.quickStats = quickStats
        self.equipment = equipment
        self.steps = steps
        self.tips = tips
        self.troubleshooting = troubleshooting
        self.servingInfo = servingInfo
    }
}

// MARK: - Serving Info

struct ServingInfo {
    let baseServings: Int
    let baseCoffeeGrams: Double
    let baseWaterGrams: Double
    let minServings: Int
    let maxServings: Int

    func scaledCoffee(for servings: Int) -> Double {
        let multiplier = Double(servings) / Double(baseServings)
        return baseCoffeeGrams * multiplier
    }

    func scaledWater(for servings: Int) -> Double {
        let multiplier = Double(servings) / Double(baseServings)
        return baseWaterGrams * multiplier
    }

    func scaledBloom(for servings: Int) -> Double {
        scaledCoffee(for: servings) * 2
    }
}

// MARK: - Supporting Models

struct QuickStats {
    let brewTime: String
    let difficulty: String
    let grindSize: String
    let ratio: String
    let idealFor: String
    let invented: String?
}

struct EquipmentItem: Identifiable {
    let id: UUID
    let name: String
    let icon: String
    let isOptional: Bool

    init(id: UUID = UUID(), name: String, icon: String, isOptional: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.isOptional = isOptional
    }
}

struct BrewGuideStep: Identifiable {
    let id: UUID
    let stepNumber: Int
    let title: String
    let instruction: String
    let timerDuration: TimeInterval?
    let timerLabel: String?

    init(
        id: UUID = UUID(),
        stepNumber: Int,
        title: String,
        instruction: String,
        timerDuration: TimeInterval? = nil,
        timerLabel: String? = nil
    ) {
        self.id = id
        self.stepNumber = stepNumber
        self.title = title
        self.instruction = instruction
        self.timerDuration = timerDuration
        self.timerLabel = timerLabel
    }
}

struct TroubleshootingItem: Identifiable {
    let id: UUID
    let problem: String
    let solution: String

    init(id: UUID = UUID(), problem: String, solution: String) {
        self.id = id
        self.problem = problem
        self.solution = solution
    }
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "orange"
        case .hard: return "red"
        }
    }
}

// MARK: - Brew Guide Extension for Scaling

extension BrewGuide {
    func stepsForServings(_ servings: Int) -> [BrewGuideStep] {
        let scaledCoffee = Int(servingInfo.scaledCoffee(for: servings))
        let scaledWater = Int(servingInfo.scaledWater(for: servings))
        let scaledBloom = Int(servingInfo.scaledBloom(for: servings))

        return steps.map { step in
            var instruction = step.instruction

            // Replace coffee amounts
            instruction = instruction.replacingOccurrences(
                of: "\(Int(servingInfo.baseCoffeeGrams))g",
                with: "\(scaledCoffee)g"
            )

            // Replace water amounts (total water)
            instruction = instruction.replacingOccurrences(
                of: "\(Int(servingInfo.baseWaterGrams))g",
                with: "\(scaledWater)g"
            )

            // Replace bloom amounts (2x coffee)
            let baseBloom = Int(servingInfo.baseCoffeeGrams * 2)
            instruction = instruction.replacingOccurrences(
                of: "\(baseBloom)g",
                with: "\(scaledBloom)g"
            )

            // For French Press: handle the "to Xg total" pattern
            if method == .frenchPress {
                // Replace "to 600g total" with scaled amount
                instruction = instruction.replacingOccurrences(
                    of: "to \(Int(servingInfo.baseWaterGrams))g total",
                    with: "to \(scaledWater)g total"
                )
            }

            // For Chemex: handle "Pour to Xg total" pattern
            if method == .chemex {
                instruction = instruction.replacingOccurrences(
                    of: "Pour to \(Int(servingInfo.baseWaterGrams))g total",
                    with: "Pour to \(scaledWater)g total"
                )
            }

            return BrewGuideStep(
                id: step.id,
                stepNumber: step.stepNumber,
                title: step.title,
                instruction: instruction,
                timerDuration: step.timerDuration,
                timerLabel: step.timerLabel
            )
        }
    }
}

// MARK: - Brew Guide Data Provider

class BrewGuideProvider {
    static let shared = BrewGuideProvider()

    private init() {}

    var allGuides: [BrewGuide] {
        [chemexGuide, frenchPressGuide]
    }

    func guide(for method: BrewMethod) -> BrewGuide? {
        allGuides.first { $0.method == method }
    }

    // MARK: - Chemex Guide

    private var chemexGuide: BrewGuide {
        BrewGuide(
            method: .chemex,
            name: "Chemex",
            shortDescription: "Clean, bright cup with clarity and complexity",
            fullDescription: "The Chemex produces a clean, bright cup with exceptional clarity and complexity. Its thick bonded paper filters remove oils and sediment for a tea-like body while preserving delicate flavor notes. Perfect for showcasing the nuanced flavors of single-origin coffees.",
            heroImage: "triangle.fill",
            difficulty: .medium,
            brewTimeRange: "3.5-4.5 min",
            quickStats: QuickStats(
                brewTime: "3.5-4.5 minutes",
                difficulty: "Medium",
                grindSize: "Medium-coarse",
                ratio: "1:16 (coffee:water)",
                idealFor: "Bright, clean, fruity coffees",
                invented: "1941 by Dr. Peter Schlumbohm"
            ),
            equipment: [
                EquipmentItem(name: "Chemex brewer", icon: "triangle.fill"),
                EquipmentItem(name: "Chemex bonded filter", icon: "doc.fill"),
                EquipmentItem(name: "Coffee grinder", icon: "circle.grid.cross.fill"),
                EquipmentItem(name: "Gooseneck kettle", icon: "drop.fill"),
                EquipmentItem(name: "Kitchen scale", icon: "scalemass.fill"),
                EquipmentItem(name: "Timer", icon: "timer"),
                EquipmentItem(name: "Thermometer", icon: "thermometer", isOptional: true)
            ],
            steps: [
                BrewGuideStep(
                    stepNumber: 1,
                    title: "Boil Water",
                    instruction: "Heat water to 195-205°F (90-96°C). If you don't have a thermometer, bring water to a boil and let it rest for 30 seconds."
                ),
                BrewGuideStep(
                    stepNumber: 2,
                    title: "Prepare Filter",
                    instruction: "Fold the Chemex filter into a cone with the triple-fold facing the spout. Place in brewer and rinse with hot water to remove paper taste and preheat the vessel. Discard rinse water.",
                    timerDuration: 30,
                    timerLabel: "Rinse & Preheat"
                ),
                BrewGuideStep(
                    stepNumber: 3,
                    title: "Add Coffee",
                    instruction: "Add 30g of medium-coarse ground coffee (about the texture of kosher salt). Gently shake the Chemex to level the grounds, creating a flat bed."
                ),
                BrewGuideStep(
                    stepNumber: 4,
                    title: "Bloom",
                    instruction: "Start timer and pour 60g of water (2x coffee weight) in a spiral motion, ensuring all grounds are saturated. Let bloom for 30-45 seconds as CO2 escapes.",
                    timerDuration: 45,
                    timerLabel: "Bloom Phase"
                ),
                BrewGuideStep(
                    stepNumber: 5,
                    title: "Main Pour",
                    instruction: "Pour water in slow, steady circles from center outward, avoiding the filter edges. Pour to 480g total, maintaining a consistent water level. This should take 2-3 minutes from start.",
                    timerDuration: 180,
                    timerLabel: "Main Pour"
                ),
                BrewGuideStep(
                    stepNumber: 6,
                    title: "Final Draw",
                    instruction: "Once all water has passed through (around 4-4.5 minutes total), remove and discard the filter. The coffee bed should be flat.",
                    timerDuration: 60,
                    timerLabel: "Drawdown"
                ),
                BrewGuideStep(
                    stepNumber: 7,
                    title: "Serve",
                    instruction: "Give the Chemex a gentle swirl to mix the brew. Pour into your favorite cup and enjoy immediately for best flavor."
                )
            ],
            tips: [
                "Use coffee roasted within 2-4 weeks for optimal flavor",
                "Grind just before brewing to preserve aromatics",
                "Pour in a slow, controlled circular motion - avoid pouring directly on the filter",
                "Total brew time should be 4-4.5 minutes; adjust grind if faster or slower",
                "The coffee bed should be flat after brewing - if it's domed or channeled, adjust your technique",
                "Keep your kettle height consistent during pouring for even extraction",
                "Room temperature is important - cold kitchen can slow extraction"
            ],
            troubleshooting: [
                TroubleshootingItem(
                    problem: "Coffee tastes bitter or harsh",
                    solution: "Your grind is too fine or water is too hot. Try a coarser grind or lower water temperature (195°F)."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes weak or sour",
                    solution: "Your grind is too coarse or water isn't hot enough. Try a finer grind or increase water temperature (205°F)."
                ),
                TroubleshootingItem(
                    problem: "Brew time is too slow (over 5 minutes)",
                    solution: "Grind is too fine or you're pouring too fast initially. Use a coarser grind and pour more gently during bloom."
                ),
                TroubleshootingItem(
                    problem: "Brew time is too fast (under 3.5 minutes)",
                    solution: "Grind is too coarse. Try a finer grind setting on your grinder."
                ),
                TroubleshootingItem(
                    problem: "Coffee bed is uneven or channeled",
                    solution: "Ensure grounds are level before brewing. Pour in consistent circles, avoiding the edges. Don't disturb the bed during brewing."
                ),
                TroubleshootingItem(
                    problem: "Too much sediment in cup",
                    solution: "Make sure you're using authentic Chemex bonded filters (thicker than standard). Rinse the filter thoroughly before brewing."
                )
            ],
            servingInfo: ServingInfo(
                baseServings: 2,
                baseCoffeeGrams: 30,
                baseWaterGrams: 480,
                minServings: 1,
                maxServings: 6
            )
        )
    }

    // MARK: - French Press Guide

    private var frenchPressGuide: BrewGuide {
        BrewGuide(
            method: .frenchPress,
            name: "French Press",
            shortDescription: "Full-bodied, rich cup with natural oils and depth",
            fullDescription: "The French Press (also called a press pot or plunger pot) is a full immersion brewing method that produces a rich, full-bodied cup with all the natural oils and fine particles intact. Perfect for those who enjoy a heavier, more textured coffee experience with deep, bold flavors.",
            heroImage: "cylinder.fill",
            difficulty: .easy,
            brewTimeRange: "4-5 min",
            quickStats: QuickStats(
                brewTime: "4-5 minutes",
                difficulty: "Easy",
                grindSize: "Coarse",
                ratio: "1:15 (coffee:water)",
                idealFor: "Bold, full-bodied coffees",
                invented: "1929 in France"
            ),
            equipment: [
                EquipmentItem(name: "French Press", icon: "cylinder.fill"),
                EquipmentItem(name: "Coffee grinder", icon: "circle.grid.cross.fill"),
                EquipmentItem(name: "Kettle", icon: "drop.fill"),
                EquipmentItem(name: "Kitchen scale", icon: "scalemass.fill"),
                EquipmentItem(name: "Timer", icon: "timer"),
                EquipmentItem(name: "Spoon for stirring", icon: "fork.knife"),
                EquipmentItem(name: "Thermometer", icon: "thermometer", isOptional: true)
            ],
            steps: [
                BrewGuideStep(
                    stepNumber: 1,
                    title: "Boil Water",
                    instruction: "Heat water to 195-205°F (90-96°C). For a 1-liter French Press, you'll need about 675ml of water. If you don't have a thermometer, bring water to a boil and let it rest for 45 seconds."
                ),
                BrewGuideStep(
                    stepNumber: 2,
                    title: "Preheat French Press",
                    instruction: "Pour hot water into the empty French Press to preheat it. Swirl the water around, then discard. This helps maintain brewing temperature.",
                    timerDuration: 20,
                    timerLabel: "Preheat"
                ),
                BrewGuideStep(
                    stepNumber: 3,
                    title: "Add Coffee",
                    instruction: "Add 45g of coarsely ground coffee to the preheated French Press. The grind should resemble breadcrumbs or sea salt - too fine and you'll get muddy, over-extracted coffee."
                ),
                BrewGuideStep(
                    stepNumber: 4,
                    title: "Start Bloom",
                    instruction: "Start your timer and pour about 90g of hot water (2x coffee weight), ensuring all grounds are saturated. Stir gently with a spoon to break up any dry clumps.",
                    timerDuration: 30,
                    timerLabel: "Bloom"
                ),
                BrewGuideStep(
                    stepNumber: 5,
                    title: "Add Remaining Water",
                    instruction: "Pour the remaining water (to 675g total) in a circular motion. Place the lid on top with the plunger pulled all the way up. Don't plunge yet!"
                ),
                BrewGuideStep(
                    stepNumber: 6,
                    title: "Steep",
                    instruction: "Let the coffee steep for 4 minutes total (from when you started the timer). During this time, the coffee is extracting in the hot water. Resist the urge to stir or disturb it.",
                    timerDuration: 210,
                    timerLabel: "Steep Time"
                ),
                BrewGuideStep(
                    stepNumber: 7,
                    title: "Stir the Crust",
                    instruction: "After 4 minutes, remove the lid and use a spoon to gently stir and break the crust of grounds floating on top. You can also skim off any foam if desired."
                ),
                BrewGuideStep(
                    stepNumber: 8,
                    title: "Plunge & Serve",
                    instruction: "Replace the lid and slowly press the plunger down with steady, even pressure. This should take about 20-30 seconds. Pour immediately into cups to prevent over-extraction."
                )
            ],
            tips: [
                "Use fresh, coarsely ground coffee - grind consistency is crucial for French Press",
                "Always preheat your French Press to maintain temperature stability",
                "Don't press the plunger too quickly - slow and steady prevents grounds from escaping",
                "Pour all the coffee immediately after plunging - leaving it in the press continues extraction",
                "Some sediment at the bottom of your cup is normal and part of the French Press character",
                "For a cleaner cup, you can use a paper filter between the plunger and coffee",
                "Experiment with steep time: 3 minutes for lighter, 5 minutes for bolder",
                "Use a burr grinder for consistent coarse grounds"
            ],
            troubleshooting: [
                TroubleshootingItem(
                    problem: "Coffee tastes bitter or over-extracted",
                    solution: "Your grind might be too fine or steep time too long. Try a coarser grind and reduce steep time to 3-3.5 minutes. Also ensure water isn't too hot (over 205°F)."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes weak or under-extracted",
                    solution: "Your grind might be too coarse or water not hot enough. Try a slightly finer grind or increase steep time to 5 minutes. Ensure water is at least 195°F."
                ),
                TroubleshootingItem(
                    problem: "Too much sediment in cup",
                    solution: "Grind is too fine. Use a coarser grind and press slowly. Let coffee settle for 30 seconds after plunging before pouring. Pour gently and stop before reaching the very bottom."
                ),
                TroubleshootingItem(
                    problem: "Plunger is hard to press down",
                    solution: "Grind is too fine causing a clog. Use a much coarser grind next time. For this brew, try plunging slowly with steady pressure."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes muddy or gritty",
                    solution: "Grind is too fine. French Press requires a coarse grind similar to sea salt. Consider using a burr grinder for more consistent particles."
                ),
                TroubleshootingItem(
                    problem: "Coffee cools down too quickly",
                    solution: "Preheat your French Press thoroughly with hot water before brewing. Also consider preheating your cups. Use a thermal carafe if available."
                )
            ],
            servingInfo: ServingInfo(
                baseServings: 3,
                baseCoffeeGrams: 45,
                baseWaterGrams: 675,
                minServings: 1,
                maxServings: 8
            )
        )
    }
}
