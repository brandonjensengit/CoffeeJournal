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
    case servingStyle = 3
    case roastLevel = 4
    case grindSize = 5
    case brewRatio = 6
    case waterTemp = 7
    case brewTime = 8
    case customizations = 9
    case rating = 10
    case tastingNotes = 11
    case personalNotes = 12
    case photo = 13
    case review = 14

    var id: Int { rawValue }

    var question: String {
        switch self {
        case .coffeeName:
            return "Coffee name?"
        case .roaster:
            return "Who roasted it?"
        case .brewMethod:
            return "How are you brewing it?"
        case .servingStyle:
            return "Hot or Iced?"
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
        case .customizations:
            return "Keep it pure or customize?"
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
        case .customizations, .personalNotes, .photo:
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
