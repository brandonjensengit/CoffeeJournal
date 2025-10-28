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
        [chemexGuide, v60Guide, aeroPress, frenchPressGuide, espresso, coldBrew, mokaPot]
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

    // MARK: - V60 Pour Over Guide

    private var v60Guide: BrewGuide {
        BrewGuide(
            method: .pourOver,
            name: "Pour Over (V60)",
            shortDescription: "Delicate, nuanced cup with exceptional clarity",
            fullDescription: "The Hario V60 is a cone-shaped dripper with spiral ridges and a large opening. It produces a clean, bright cup with exceptional clarity and nuance. The V60 requires more attention and technique than other methods, but rewards you with a cup that highlights subtle flavor notes and aromatics.",
            heroImage: "triangle",
            difficulty: .medium,
            brewTimeRange: "2.5-3 min",
            quickStats: QuickStats(
                brewTime: "2.5-3 minutes",
                difficulty: "Medium",
                grindSize: "Medium-fine",
                ratio: "1:16 (coffee:water)",
                idealFor: "Bright, complex, fruity coffees",
                invented: "2004 by Hario, Japan"
            ),
            equipment: [
                EquipmentItem(name: "V60 dripper", icon: "triangle"),
                EquipmentItem(name: "V60 paper filter", icon: "doc.fill"),
                EquipmentItem(name: "Coffee grinder", icon: "circle.grid.cross.fill"),
                EquipmentItem(name: "Gooseneck kettle", icon: "drop.fill"),
                EquipmentItem(name: "Kitchen scale", icon: "scalemass.fill"),
                EquipmentItem(name: "Timer", icon: "timer"),
                EquipmentItem(name: "Carafe or cup", icon: "cup.and.saucer.fill"),
                EquipmentItem(name: "Thermometer", icon: "thermometer", isOptional: true)
            ],
            steps: [
                BrewGuideStep(
                    stepNumber: 1,
                    title: "Boil Water",
                    instruction: "Heat water to 195-205°F (90-96°C). You'll need about 250ml. Higher temperatures (205°F) for light roasts, lower (195°F) for dark roasts."
                ),
                BrewGuideStep(
                    stepNumber: 2,
                    title: "Prepare Filter",
                    instruction: "Place the V60 filter in the dripper and rinse thoroughly with hot water. This removes paper taste and preheats the brewer. Discard the rinse water.",
                    timerDuration: 20,
                    timerLabel: "Rinse"
                ),
                BrewGuideStep(
                    stepNumber: 3,
                    title: "Add Coffee",
                    instruction: "Add 15g of medium-fine ground coffee (slightly finer than Chemex, like granulated sugar). Create a flat, level bed by gently tapping the V60."
                ),
                BrewGuideStep(
                    stepNumber: 4,
                    title: "Bloom",
                    instruction: "Start timer. Pour 30g of water in a spiral motion from center outward, saturating all grounds. Let bloom for 30-45 seconds as CO2 releases.",
                    timerDuration: 45,
                    timerLabel: "Bloom Phase"
                ),
                BrewGuideStep(
                    stepNumber: 5,
                    title: "First Pour",
                    instruction: "At 0:45, slowly pour to 125g total in a spiral motion from center outward. Pour slowly and steadily, maintaining gentle agitation of the grounds.",
                    timerDuration: 30,
                    timerLabel: "First Pour"
                ),
                BrewGuideStep(
                    stepNumber: 6,
                    title: "Second Pour",
                    instruction: "At 1:15, pour to 240g total using the same spiral technique. Keep the water level consistent, avoiding the dripper walls.",
                    timerDuration: 30,
                    timerLabel: "Second Pour"
                ),
                BrewGuideStep(
                    stepNumber: 7,
                    title: "Final Drawdown",
                    instruction: "Let all water drain through completely. Total brew time should be 2:30-3:00. The coffee bed should be flat with grounds on the sides.",
                    timerDuration: 60,
                    timerLabel: "Drawdown"
                ),
                BrewGuideStep(
                    stepNumber: 8,
                    title: "Serve",
                    instruction: "Remove the V60 and give your cup a gentle swirl to integrate the brew. Enjoy immediately for best flavor."
                )
            ],
            tips: [
                "Grind size is crucial - adjust based on brew time. Too fast = grind finer, too slow = grind coarser",
                "Pour in slow, controlled circles without touching the filter walls",
                "Keep the water level consistent during pours for even extraction",
                "Light, gentle pours work best - aggressive pouring can cause channeling",
                "Fresh coffee (roasted within 2 weeks) shows the most clarity and complexity",
                "The V60's large hole means flow rate is controlled by your grind and pour technique",
                "Experiment with pulse pouring (multiple small pours) vs continuous pouring"
            ],
            troubleshooting: [
                TroubleshootingItem(
                    problem: "Brew time too fast (under 2 minutes)",
                    solution: "Grind finer or pour more gently. Fast flow means under-extraction and sour, weak coffee."
                ),
                TroubleshootingItem(
                    problem: "Brew time too slow (over 3.5 minutes)",
                    solution: "Grind coarser or pour more aggressively. Slow flow causes bitter, over-extracted coffee."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes bitter",
                    solution: "Use cooler water (195°F), grind coarser, or shorten brew time. May also indicate over-roasted beans."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes sour or weak",
                    solution: "Use hotter water (205°F), grind finer, or extend contact time. Ensure bloom is thorough."
                ),
                TroubleshootingItem(
                    problem: "Uneven coffee bed or channeling",
                    solution: "Create a level bed before brewing. Pour in consistent circles. Don't pour directly on filter walls."
                ),
                TroubleshootingItem(
                    problem: "Coffee has papery taste",
                    solution: "Rinse the filter more thoroughly with hot water before brewing. Use quality V60 filters."
                )
            ],
            servingInfo: ServingInfo(
                baseServings: 1,
                baseCoffeeGrams: 15,
                baseWaterGrams: 240,
                minServings: 1,
                maxServings: 4
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

    // MARK: - AeroPress Guide

    private var aeroPress: BrewGuide {
        BrewGuide(
            method: .aeroPress,
            name: "AeroPress",
            shortDescription: "Versatile, full-bodied cup with quick brew time",
            fullDescription: "The AeroPress is a versatile, portable brewing device that uses air pressure to push water through coffee grounds. It produces a rich, full-bodied cup similar to espresso but with less intensity. Known for its quick brew time, easy cleanup, and ability to experiment with different recipes and techniques.",
            heroImage: "cylinder.split.1x2",
            difficulty: .easy,
            brewTimeRange: "1-2 min",
            quickStats: QuickStats(
                brewTime: "1-2 minutes",
                difficulty: "Easy",
                grindSize: "Fine to medium",
                ratio: "1:15 (coffee:water)",
                idealFor: "Travel, quick cups, experimentation",
                invented: "2005 by Alan Adler"
            ),
            equipment: [
                EquipmentItem(name: "AeroPress", icon: "cylinder.split.1x2"),
                EquipmentItem(name: "AeroPress filter", icon: "circle.fill"),
                EquipmentItem(name: "Coffee grinder", icon: "circle.grid.cross.fill"),
                EquipmentItem(name: "Kettle", icon: "drop.fill"),
                EquipmentItem(name: "Kitchen scale", icon: "scalemass.fill"),
                EquipmentItem(name: "Timer", icon: "timer"),
                EquipmentItem(name: "Stirrer (included)", icon: "fork.knife"),
                EquipmentItem(name: "Mug", icon: "cup.and.saucer.fill")
            ],
            steps: [
                BrewGuideStep(
                    stepNumber: 1,
                    title: "Boil Water",
                    instruction: "Heat water to 175-185°F (80-85°C). AeroPress uses lower temperature than other methods. If you don't have a thermometer, let boiling water cool for 90 seconds."
                ),
                BrewGuideStep(
                    stepNumber: 2,
                    title: "Prepare AeroPress",
                    instruction: "Insert a paper filter into the cap and rinse with hot water. Attach cap to chamber. Place chamber on your mug with numbers facing you (standard method).",
                    timerDuration: 15,
                    timerLabel: "Setup"
                ),
                BrewGuideStep(
                    stepNumber: 3,
                    title: "Add Coffee",
                    instruction: "Add 17g of fine to medium ground coffee (similar to table salt). The grind should be finer than pour over but coarser than espresso."
                ),
                BrewGuideStep(
                    stepNumber: 4,
                    title: "Add Water & Stir",
                    instruction: "Start timer. Pour 255g of water, ensuring all grounds are saturated. Stir gently with the paddle for 10 seconds to ensure even extraction.",
                    timerDuration: 10,
                    timerLabel: "Stir"
                ),
                BrewGuideStep(
                    stepNumber: 5,
                    title: "Insert Plunger & Wait",
                    instruction: "Insert the plunger about 1cm into the chamber to create a vacuum seal. This stops dripping and helps maintain temperature. Wait until 1:15 total.",
                    timerDuration: 65,
                    timerLabel: "Steep"
                ),
                BrewGuideStep(
                    stepNumber: 6,
                    title: "Press",
                    instruction: "Press down gently and steadily for 20-30 seconds. Stop when you hear a hissing sound (air escaping). Don't press all the way to avoid bitter flavors.",
                    timerDuration: 30,
                    timerLabel: "Press"
                ),
                BrewGuideStep(
                    stepNumber: 7,
                    title: "Dilute & Serve",
                    instruction: "The brew is concentrated. Add 50-100ml hot water to taste, or enjoy as-is for a stronger cup. Stir and serve immediately."
                )
            ],
            tips: [
                "Experiment with grind size - finer for stronger, coarser for lighter",
                "Lower temperatures (175°F) highlight sweetness, higher (185°F) increase extraction",
                "The 'inverted method' (flipping the AeroPress) prevents dripping during brewing",
                "Press slowly and consistently - rushing causes bitterness",
                "AeroPress is incredibly forgiving and great for experimentation",
                "Metal filters (reusable) produce more oils and body than paper",
                "Don't press all the way - stop at the hiss to avoid over-extraction",
                "Try the 'bypass method' - brew concentrated then dilute to taste"
            ],
            troubleshooting: [
                TroubleshootingItem(
                    problem: "Difficult to press / too much resistance",
                    solution: "Grind coarser or use less coffee. Fine grinds create too much resistance."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes weak or watery",
                    solution: "Grind finer, use more coffee, increase steeping time, or add less dilution water at the end."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes bitter",
                    solution: "Use cooler water (175°F), shorter steep time, or stop pressing at the first hiss."
                ),
                TroubleshootingItem(
                    problem: "Coffee is dripping before pressing",
                    solution: "Insert plunger sooner to create vacuum seal, or try inverted method to prevent premature dripping."
                ),
                TroubleshootingItem(
                    problem: "Cloudy or muddy coffee",
                    solution: "Use finer grind or press more gently. Ensure filter is properly seated in the cap."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes sour",
                    solution: "Increase water temperature to 185°F, extend steep time, or grind finer."
                )
            ],
            servingInfo: ServingInfo(
                baseServings: 1,
                baseCoffeeGrams: 17,
                baseWaterGrams: 255,
                minServings: 1,
                maxServings: 2
            )
        )
    }

    // MARK: - Espresso Guide

    private var espresso: BrewGuide {
        BrewGuide(
            method: .espresso,
            name: "Espresso",
            shortDescription: "Intense, concentrated shot with rich crema",
            fullDescription: "Espresso is a concentrated coffee beverage brewed by forcing hot water through finely ground coffee under high pressure. It's the foundation of many popular drinks like lattes and cappuccinos. Espresso is characterized by its rich, syrupy body, intense flavor, and golden crema on top.",
            heroImage: "drop.circle.fill",
            difficulty: .hard,
            brewTimeRange: "25-30 sec",
            quickStats: QuickStats(
                brewTime: "25-30 seconds",
                difficulty: "Hard",
                grindSize: "Very fine",
                ratio: "1:2 (coffee:water)",
                idealFor: "Straight shots, milk drinks, intense flavor",
                invented: "1901 in Milan, Italy"
            ),
            equipment: [
                EquipmentItem(name: "Espresso machine", icon: "square.stack.3d.up.fill"),
                EquipmentItem(name: "Coffee grinder (burr)", icon: "circle.grid.cross.fill"),
                EquipmentItem(name: "Portafilter", icon: "circle.grid.3x3.fill"),
                EquipmentItem(name: "Tamper", icon: "circle.fill"),
                EquipmentItem(name: "Kitchen scale", icon: "scalemass.fill"),
                EquipmentItem(name: "Timer", icon: "timer"),
                EquipmentItem(name: "Espresso cup", icon: "cup.and.saucer.fill"),
                EquipmentItem(name: "Distribution tool", icon: "aqi.medium", isOptional: true)
            ],
            steps: [
                BrewGuideStep(
                    stepNumber: 1,
                    title: "Warm Machine",
                    instruction: "Turn on espresso machine and let it heat up for 15-20 minutes. Run a blank shot to warm the group head and portafilter.",
                    timerDuration: 30,
                    timerLabel: "Warmup"
                ),
                BrewGuideStep(
                    stepNumber: 2,
                    title: "Dose Coffee",
                    instruction: "Grind 18g of coffee very fine (like powdered sugar). Dose into clean, dry portafilter. Coffee should be fresh (within 3 weeks of roasting)."
                ),
                BrewGuideStep(
                    stepNumber: 3,
                    title: "Distribute Grounds",
                    instruction: "Distribute grounds evenly using WDT tool or by tapping sides. Ensure level, even distribution with no clumps. This is crucial for even extraction."
                ),
                BrewGuideStep(
                    stepNumber: 4,
                    title: "Tamp",
                    instruction: "Place portafilter on stable surface. Tamp straight down with 30lbs pressure until grounds feel firm and level. Polish with a twist."
                ),
                BrewGuideStep(
                    stepNumber: 5,
                    title: "Clean & Lock",
                    instruction: "Wipe any loose grounds from rim of portafilter. Lock portafilter into group head immediately to keep coffee warm."
                ),
                BrewGuideStep(
                    stepNumber: 6,
                    title: "Pull Shot",
                    instruction: "Place preheated cup under portafilter. Start extraction immediately. Aim for 36g output in 25-30 seconds. Watch for tiger striping and golden crema.",
                    timerDuration: 30,
                    timerLabel: "Extraction"
                ),
                BrewGuideStep(
                    stepNumber: 7,
                    title: "Evaluate & Serve",
                    instruction: "Stop extraction at 25-30 seconds or when flow becomes pale/blonde. Swirl cup to incorporate crema. Serve immediately while hot."
                )
            ],
            tips: [
                "Grind size is critical - adjust in small increments (1-2 clicks at a time)",
                "Aim for 1:2 ratio: 18g in, 36g out in 25-30 seconds",
                "If too fast (under 20 sec) = grind finer or use more coffee",
                "If too slow (over 35 sec) = grind coarser or use less coffee",
                "Fresh beans are essential - espresso shows every flaw",
                "Preheat everything: machine, portafilter, cups",
                "Consistent tamping pressure matters more than heavy pressure",
                "Clean your machine daily - old coffee oils taste rancid"
            ],
            troubleshooting: [
                TroubleshootingItem(
                    problem: "Shot pulls too fast (under 20 seconds)",
                    solution: "Grind finer, dose more coffee (19g), or tamp harder. Fast shots are under-extracted and sour."
                ),
                TroubleshootingItem(
                    problem: "Shot pulls too slow (over 35 seconds)",
                    solution: "Grind coarser, dose less coffee (17g), or tamp lighter. Slow shots are over-extracted and bitter."
                ),
                TroubleshootingItem(
                    problem: "Little or no crema",
                    solution: "Use fresher beans (within 2 weeks). Ensure proper tamp and grind. Check machine pressure (9 bars)."
                ),
                TroubleshootingItem(
                    problem: "Channeling (water finds path of least resistance)",
                    solution: "Distribute grounds more evenly using WDT. Tamp level. Ensure dose fills basket properly."
                ),
                TroubleshootingItem(
                    problem: "Sour, acidic taste",
                    solution: "Increase extraction time by grinding finer. Use hotter water (201°F). Ensure proper pre-infusion."
                ),
                TroubleshootingItem(
                    problem: "Bitter, harsh taste",
                    solution: "Decrease extraction time by grinding coarser. Lower water temperature. Use fresher beans."
                )
            ],
            servingInfo: ServingInfo(
                baseServings: 1,
                baseCoffeeGrams: 18,
                baseWaterGrams: 36,
                minServings: 1,
                maxServings: 2
            )
        )
    }

    // MARK: - Cold Brew Guide

    private var coldBrew: BrewGuide {
        BrewGuide(
            method: .coldBrew,
            name: "Cold Brew",
            shortDescription: "Smooth, sweet concentrate brewed over 12-24 hours",
            fullDescription: "Cold brew is made by steeping coarse coffee grounds in cold water for an extended period (12-24 hours). The slow extraction produces a smooth, sweet, low-acid concentrate that can be diluted with water, milk, or ice. Perfect for hot summer days or anyone who prefers a mellow coffee flavor.",
            heroImage: "snowflake",
            difficulty: .easy,
            brewTimeRange: "12-24 hrs",
            quickStats: QuickStats(
                brewTime: "12-24 hours",
                difficulty: "Easy",
                grindSize: "Extra coarse",
                ratio: "1:8 (coffee:water) for concentrate",
                idealFor: "Iced coffee, low acidity, smooth flavor",
                invented: "1600s in Japan, popularized recently"
            ),
            equipment: [
                EquipmentItem(name: "Large jar or pitcher", icon: "jar.fill"),
                EquipmentItem(name: "Coffee grinder", icon: "circle.grid.cross.fill"),
                EquipmentItem(name: "Kitchen scale", icon: "scalemass.fill"),
                EquipmentItem(name: "Fine mesh strainer", icon: "line.3.horizontal.decrease.circle"),
                EquipmentItem(name: "Coffee filters or cheesecloth", icon: "doc.fill"),
                EquipmentItem(name: "Storage container", icon: "refrigerator.fill")
            ],
            steps: [
                BrewGuideStep(
                    stepNumber: 1,
                    title: "Grind Coffee",
                    instruction: "Grind 100g of coffee extra coarse - similar to raw sugar or peppercorns. Coarse grind prevents over-extraction and bitterness during long steep."
                ),
                BrewGuideStep(
                    stepNumber: 2,
                    title: "Combine Coffee & Water",
                    instruction: "Add ground coffee to large jar. Pour 800g of cold, filtered water over grounds. Stir gently to ensure all grounds are saturated."
                ),
                BrewGuideStep(
                    stepNumber: 3,
                    title: "Steep",
                    instruction: "Cover jar and let steep at room temperature for 12-18 hours, or in refrigerator for 18-24 hours. Longer steeping creates stronger concentrate.",
                    timerDuration: 300,
                    timerLabel: "Steeping (5 min shown)"
                ),
                BrewGuideStep(
                    stepNumber: 4,
                    title: "First Strain",
                    instruction: "After steeping, stir the mixture. Pour through fine mesh strainer into another container to remove most grounds."
                ),
                BrewGuideStep(
                    stepNumber: 5,
                    title: "Second Strain",
                    instruction: "Line strainer with coffee filter or cheesecloth. Strain liquid again slowly to remove fine particles. This creates clean, sediment-free concentrate."
                ),
                BrewGuideStep(
                    stepNumber: 6,
                    title: "Store",
                    instruction: "Transfer concentrate to clean, airtight container. Store in refrigerator for up to 2 weeks."
                ),
                BrewGuideStep(
                    stepNumber: 7,
                    title: "Serve",
                    instruction: "Dilute concentrate 1:1 with water, milk, or over ice. Adjust ratio to taste. Add sweeteners or flavors as desired."
                )
            ],
            tips: [
                "Grind size is crucial - too fine creates bitter, muddy brew",
                "Use quality, filtered water - it makes up most of the drink",
                "Room temperature steeping (12-18 hrs) extracts more flavor than refrigerator",
                "Refrigerator steeping (18-24 hrs) is safer if kitchen is very warm",
                "Start with 1:1 dilution ratio and adjust to preference",
                "Cold brew has 2-3x caffeine of regular coffee when undiluted",
                "Use medium to dark roasts for chocolatey, smooth flavors",
                "Light roasts work but may taste grassy or tea-like"
            ],
            troubleshooting: [
                TroubleshootingItem(
                    problem: "Coffee tastes weak or watery",
                    solution: "Steep longer (up to 24 hours), use more coffee (1:7 ratio), or dilute less when serving."
                ),
                TroubleshootingItem(
                    problem: "Coffee tastes bitter or harsh",
                    solution: "Grind coarser, steep for less time (10-12 hours), or use less coffee. Over-extraction causes bitterness."
                ),
                TroubleshootingItem(
                    problem: "Muddy, gritty texture",
                    solution: "Grind much coarser and strain twice with proper coffee filters, not just mesh strainer."
                ),
                TroubleshootingItem(
                    problem: "Sour or unpleasant taste",
                    solution: "Steep longer to increase extraction. Ensure all grounds are saturated. Use fresher coffee beans."
                ),
                TroubleshootingItem(
                    problem: "Mold or fermentation smell",
                    solution: "Water was too warm or steep time too long. Keep below 75°F. Don't exceed 24 hours."
                ),
                TroubleshootingItem(
                    problem: "Concentrate goes bad quickly",
                    solution: "Ensure container is clean and airtight. Store in coldest part of refrigerator. Use within 2 weeks."
                )
            ],
            servingInfo: ServingInfo(
                baseServings: 4,
                baseCoffeeGrams: 100,
                baseWaterGrams: 800,
                minServings: 2,
                maxServings: 10
            )
        )
    }

    // MARK: - Moka Pot Guide

    private var mokaPot: BrewGuide {
        BrewGuide(
            method: .mokaPot,
            name: "Moka Pot",
            shortDescription: "Rich, espresso-style coffee brewed on stovetop",
            fullDescription: "The Moka pot (also called stovetop espresso maker) is an Italian icon that brews rich, strong coffee using steam pressure. While not true espresso, it produces an intense, full-bodied cup with some crema. Popular in European households for its simplicity, reliability, and ritualistic brewing process.",
            heroImage: "flame.fill",
            difficulty: .medium,
            brewTimeRange: "4-5 min",
            quickStats: QuickStats(
                brewTime: "4-5 minutes",
                difficulty: "Medium",
                grindSize: "Fine to medium-fine",
                ratio: "1:10 (coffee:water)",
                idealFor: "Strong coffee, milk drinks, traditional Italian style",
                invented: "1933 by Alfonso Bialetti"
            ),
            equipment: [
                EquipmentItem(name: "Moka pot", icon: "flame.fill"),
                EquipmentItem(name: "Coffee grinder", icon: "circle.grid.cross.fill"),
                EquipmentItem(name: "Kitchen scale", icon: "scalemass.fill"),
                EquipmentItem(name: "Stovetop or burner", icon: "flame"),
                EquipmentItem(name: "Hot water kettle", icon: "drop.fill", isOptional: true),
                EquipmentItem(name: "Towel or pot holder", icon: "hand.raised.fill")
            ],
            steps: [
                BrewGuideStep(
                    stepNumber: 1,
                    title: "Boil Water",
                    instruction: "Heat 300g of water to near-boiling. Starting with hot water prevents metallic taste and reduces stovetop time, protecting coffee from burning."
                ),
                BrewGuideStep(
                    stepNumber: 2,
                    title: "Prepare Lower Chamber",
                    instruction: "Fill the lower chamber with hot water up to the safety valve. Do not exceed the valve - it's a safety feature."
                ),
                BrewGuideStep(
                    stepNumber: 3,
                    title: "Add Coffee",
                    instruction: "Grind 30g of coffee fine to medium-fine (finer than drip, coarser than espresso). Fill the filter basket completely, level it off. Do not tamp."
                ),
                BrewGuideStep(
                    stepNumber: 4,
                    title: "Assemble",
                    instruction: "Place filter basket in lower chamber. Screw upper chamber on firmly but not too tight. Ensure good seal with no coffee grounds on rim."
                ),
                BrewGuideStep(
                    stepNumber: 5,
                    title: "Heat on Stove",
                    instruction: "Place on stovetop over medium-low heat. Keep lid open to watch the coffee. Too high heat causes bitter, burnt flavors.",
                    timerDuration: 60,
                    timerLabel: "Heating"
                ),
                BrewGuideStep(
                    stepNumber: 6,
                    title: "Watch for Coffee",
                    instruction: "Coffee will start flowing into upper chamber. You'll hear gurgling. When you see honey-colored stream turning pale, remove from heat immediately.",
                    timerDuration: 120,
                    timerLabel: "Brewing"
                ),
                BrewGuideStep(
                    stepNumber: 7,
                    title: "Cool & Serve",
                    instruction: "Run bottom chamber under cold water or place on wet towel to stop extraction. Pour immediately into cups. Stir before serving to mix layers."
                )
            ],
            tips: [
                "Always use hot (not cold) water in lower chamber to reduce stovetop time",
                "Medium-low heat is key - high heat burns coffee and damages pot",
                "Don't tamp the coffee - just fill and level the basket",
                "Remove from heat when stream turns pale to avoid bitter extraction",
                "Clean thoroughly after each use but never use soap",
                "Grind slightly coarser if coffee tastes bitter",
                "Leave lid open while brewing to monitor the process",
                "Some prefer running cold water on base to stop extraction immediately"
            ],
            troubleshooting: [
                TroubleshootingItem(
                    problem: "Coffee tastes burnt or bitter",
                    solution: "Use lower heat setting. Remove from heat earlier. Start with hot (not cold) water in lower chamber."
                ),
                TroubleshootingItem(
                    problem: "Weak, watery coffee",
                    solution: "Grind finer, use more coffee, fill basket completely. Ensure good seal between chambers."
                ),
                TroubleshootingItem(
                    problem: "Coffee spurts violently or too fast",
                    solution: "Heat is too high. Reduce to medium-low. Grind slightly finer to slow flow."
                ),
                TroubleshootingItem(
                    problem: "Little or no coffee comes out",
                    solution: "Grind is too fine causing clog. Safety valve might be blocked - check and clean. Use less coffee."
                ),
                TroubleshootingItem(
                    problem: "Metallic taste",
                    solution: "Don't use cold water in base. Clean pot thoroughly. Season new pots by making several batches."
                ),
                TroubleshootingItem(
                    problem: "Steam leaking from sides",
                    solution: "Tighten upper chamber. Replace rubber gasket if old. Clean threads on both chambers."
                )
            ],
            servingInfo: ServingInfo(
                baseServings: 2,
                baseCoffeeGrams: 30,
                baseWaterGrams: 300,
                minServings: 1,
                maxServings: 6
            )
        )
    }
}
