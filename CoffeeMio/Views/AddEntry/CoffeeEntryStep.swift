//
//  CoffeeEntryStep.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

enum CoffeeEntryStep: Int, CaseIterable, Identifiable {
    case coffeeName = 0
    case roaster = 1
    case brewMethod = 2
    case roastLevel = 3
    case grindSize = 4
    case brewRatio = 5
    case waterTemp = 6
    case brewTime = 7
    case rating = 8
    case tastingNotes = 9
    case personalNotes = 10
    case photo = 11
    case review = 12

    var id: Int { rawValue }

    var question: String {
        switch self {
        case .coffeeName:
            return "What coffee are you brewing today?"
        case .roaster:
            return "Who roasted it?"
        case .brewMethod:
            return "How are you brewing it?"
        case .roastLevel:
            return "What's the roast level?"
        case .grindSize:
            return "How fine did you grind it?"
        case .brewRatio:
            return "What's your brew ratio?"
        case .waterTemp:
            return "How hot is the water?"
        case .brewTime:
            return "How long will it brew?"
        case .rating:
            return "How was it?"
        case .tastingNotes:
            return "What flavors did you taste?"
        case .personalNotes:
            return "Any notes to remember?"
        case .photo:
            return "Want to add a photo?"
        case .review:
            return "Looking good! Ready to save?"
        }
    }

    var isOptional: Bool {
        switch self {
        case .personalNotes, .photo:
            return true
        default:
            return false
        }
    }

    var encouragementMessage: String? {
        switch self {
        case .rating:
            return "Excellent!"
        case .brewMethod:
            return "Great choice!"
        case .review:
            return "Coffee logged! ☕️"
        default:
            return nil
        }
    }

    var totalSteps: Int {
        CoffeeEntryStep.allCases.count
    }

    var progress: Double {
        Double(rawValue + 1) / Double(totalSteps)
    }

    var stepNumber: Int {
        rawValue + 1
    }
}
