//
//  AddEntryView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var temperatureManager = TemperatureManager.shared

    // Current step tracking
    @State private var currentStep: CoffeeEntryStep = .coffeeName
    @State private var stepHistory: [CoffeeEntryStep] = []

    // Entry data
    @State private var coffeeName = ""
    @State private var roaster = ""
    @State private var brewMethod: BrewMethod? = nil
    @State private var roastLevel: RoastLevel? = nil
    @State private var grindSize: Double = 5.0
    @State private var coffeeGrams: Double = 18.0
    @State private var waterGrams: Double = 300.0
    @State private var waterTemp: Double = TemperatureManager.shared.defaultTemperature()
    @State private var brewMinutes: Int = 3
    @State private var brewSeconds: Int = 0
    @State private var rating: Double = 3.0
    @State private var tastingNotes: [String] = []
    @State private var personalNotes = ""
    @State private var selectedPhoto: UIImage?
    @State private var dateLogged = Date()

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Step container with current step content
                StepContainerView(
                    currentStep: currentStep,
                    canGoBack: !stepHistory.isEmpty,
                    canSkip: currentStep.isOptional,
                    onBack: goBack,
                    onSkip: goToNextStep
                ) {
                    stepContent
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity).combined(with: .move(edge: .trailing)),
                            removal: .scale(scale: 0.95).combined(with: .opacity).combined(with: .move(edge: .leading))
                        ))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(Theme.textSecondary)
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        Group {
            switch currentStep {
            case .coffeeName:
                CoffeeNameStepView(coffeeName: $coffeeName, onNext: goToNextStep)

            case .roaster:
                RoasterStepView(roaster: $roaster, onNext: goToNextStep)

            case .brewMethod:
                BrewMethodStepView(brewMethod: $brewMethod, onNext: goToNextStep)

            case .roastLevel:
                RoastLevelStepView(roastLevel: $roastLevel, onNext: goToNextStep)

            case .grindSize:
                GrindSizeStepView(grindSize: $grindSize, onNext: goToNextStep)

            case .brewRatio:
                BrewRatioStepView(
                    coffeeGrams: $coffeeGrams,
                    waterGrams: $waterGrams,
                    onNext: goToNextStep
                )

            case .waterTemp:
                WaterTempStepView(waterTemp: $waterTemp, onNext: goToNextStep)

            case .brewTime:
                BrewTimeStepView(
                    brewMinutes: $brewMinutes,
                    brewSeconds: $brewSeconds,
                    onNext: goToNextStep
                )

            case .rating:
                RatingStepView(rating: $rating, onNext: goToNextStep)

            case .tastingNotes:
                TastingNotesStepView(tastingNotes: $tastingNotes, onNext: goToNextStep)

            case .personalNotes:
                PersonalNotesStepView(personalNotes: $personalNotes, onNext: goToNextStep)

            case .photo:
                PhotoStepView(selectedImage: $selectedPhoto, onNext: goToNextStep)

            case .review:
                ReviewStepView(
                    coffeeName: coffeeName,
                    roaster: roaster,
                    brewMethod: brewMethod,
                    roastLevel: roastLevel,
                    grindSize: grindSize,
                    coffeeGrams: coffeeGrams,
                    waterGrams: waterGrams,
                    waterTemp: waterTemp,
                    brewMinutes: brewMinutes,
                    brewSeconds: brewSeconds,
                    rating: rating,
                    tastingNotes: tastingNotes,
                    personalNotes: personalNotes,
                    selectedImage: selectedPhoto,
                    onSave: saveEntry
                )
            }
        }
        .id(currentStep)
    }

    private func goToNextStep() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) {
            stepHistory.append(currentStep)

            let nextStepRawValue = currentStep.rawValue + 1
            if let nextStep = CoffeeEntryStep(rawValue: nextStepRawValue) {
                currentStep = nextStep
            }
        }
    }

    private func goBack() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) {
            if let previousStep = stepHistory.popLast() {
                currentStep = previousStep
            }
        }
    }

    private func saveEntry() {
        // Ensure required fields are set
        guard let brewMethod = brewMethod,
              let roastLevel = roastLevel else {
            return
        }

        // Compress photo if exists
        let compressedPhotoData = selectedPhoto?.compressed()

        let entry = CoffeeEntry(
            coffeeName: coffeeName,
            origin: "",  // Not collected in step flow
            roaster: roaster,
            brewMethod: brewMethod,
            roastLevel: roastLevel,
            grindSize: grindSize,
            coffeeGrams: coffeeGrams,
            waterGrams: waterGrams,
            waterTemperature: temperatureManager.toCelsius(waterTemp),
            brewTimeMinutes: brewMinutes,
            brewTimeSeconds: brewSeconds,
            rating: rating,
            tastingNotes: tastingNotes,
            personalNotes: personalNotes,
            dateLogged: dateLogged,
            photoData: compressedPhotoData
        )

        modelContext.insert(entry)
        dismiss()
    }
}

// MARK: - Helper Views

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.warmOrange)

            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)

            TextField(placeholder, text: $text)
                .textFieldStyle(CustomTextFieldStyle())
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Theme.cream)
            .cornerRadius(Theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(Theme.warmOrange.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    AddEntryView()
        .modelContainer(for: CoffeeEntry.self, inMemory: true)
}
