//
//  AddEntryView.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var temperatureManager = TemperatureManager.shared

    @State private var coffeeName = ""
    @State private var origin = ""
    @State private var roaster = ""
    @State private var brewMethod: BrewMethod = .pourOver
    @State private var roastLevel: RoastLevel = .medium
    @State private var grindSize: Double = 5.0
    @State private var coffeeGrams: Double = 18.0
    @State private var waterGrams: Double = 300.0
    @State private var waterTemp: Double = TemperatureManager.shared.defaultTemperature()
    @State private var brewMinutes: Int = 3
    @State private var brewSeconds: Int = 0
    @State private var rating: Double = 3.0
    @State private var tastingNotes: [String] = []
    @State private var personalNotes = ""
    @State private var dateLogged = Date()
    @State private var selectedPhoto: UIImage?

    @State private var isDetailedMode = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacingL) {
                    // Quick/Detailed Mode Toggle
                    Picker("Mode", selection: $isDetailedMode) {
                        Text("Quick").tag(false)
                        Text("Detailed").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Coffee Info Section
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Coffee Details", icon: "cup.and.saucer.fill")

                        CustomTextField(title: "Coffee Name", text: $coffeeName, placeholder: "e.g., Ethiopian Yirgacheffe")

                        if isDetailedMode {
                            CustomTextField(title: "Origin", text: $origin, placeholder: "e.g., Ethiopia")
                        }

                        RoasterPicker(selectedRoaster: $roaster)
                    }
                    .padding(.horizontal)

                    // Brew Method
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Brew Method", icon: "drop.fill")

                        BrewMethodPicker(selectedMethod: $brewMethod)
                    }
                    .padding(.horizontal)

                    // Roast Level
                    if isDetailedMode {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            SectionHeader(title: "Roast Level", icon: "flame.fill")

                            RoastLevelIndicator(selectedLevel: $roastLevel)
                        }
                        .padding(.horizontal)
                    }

                    // Grind Size
                    if isDetailedMode {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            SectionHeader(title: "Grind Size", icon: "circle.grid.3x3.fill")

                            GrindSizeSlider(grindSize: $grindSize)
                        }
                        .padding(.horizontal)
                    }

                    // Brew Parameters
                    if isDetailedMode {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            SectionHeader(title: "Brew Parameters", icon: "chart.bar.fill")

                            HStack(spacing: Theme.spacingM) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Coffee (g)")
                                        .font(.caption)
                                        .foregroundStyle(Theme.textSecondary)

                                    TextField("18", value: $coffeeGrams, format: .number)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Water (g)")
                                        .font(.caption)
                                        .foregroundStyle(Theme.textSecondary)

                                    TextField("300", value: $waterGrams, format: .number)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Water Temp (\(temperatureManager.selectedUnit.symbol))")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                HStack {
                                    Slider(value: $waterTemp, in: temperatureManager.sliderRange(), step: 1)
                                        .tint(Theme.warmOrange)

                                    Text("\(Int(waterTemp))\(temperatureManager.selectedUnit.symbol)")
                                        .font(.system(.body, design: .rounded, weight: .semibold))
                                        .foregroundStyle(Theme.primaryBrown)
                                        .frame(width: 60)
                                }
                            }

                            HStack(spacing: Theme.spacingM) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Brew Time")
                                        .font(.caption)
                                        .foregroundStyle(Theme.textSecondary)

                                    HStack {
                                        TextField("3", value: $brewMinutes, format: .number)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(CustomTextFieldStyle())
                                            .frame(width: 60)

                                        Text("m")
                                            .foregroundStyle(Theme.textSecondary)

                                        TextField("30", value: $brewSeconds, format: .number)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(CustomTextFieldStyle())
                                            .frame(width: 60)

                                        Text("s")
                                            .foregroundStyle(Theme.textSecondary)
                                    }
                                }

                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Rating
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Rating", icon: "star.fill")

                        RatingView(rating: $rating, interactive: true)
                    }
                    .padding(.horizontal)

                    // Tasting Notes
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Tasting Notes", icon: "nose.fill")

                        TastingNotesSelector(selectedNotes: $tastingNotes)
                    }
                    .padding(.horizontal)

                    // Personal Notes
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Personal Notes", icon: "note.text")

                        TextEditor(text: $personalNotes)
                            .frame(height: 120)
                            .padding(12)
                            .background(Theme.cream)
                            .cornerRadius(Theme.cornerRadiusMedium)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                    .stroke(Theme.warmOrange.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)

                    // Photo
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Photo", icon: "camera.fill")

                        if let photo = selectedPhoto {
                            ImagePreview(image: photo) {
                                selectedPhoto = nil
                            }
                        } else {
                            ImagePicker(selectedImage: $selectedPhoto)
                        }
                    }
                    .padding(.horizontal)

                    // Date
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Date", icon: "calendar")

                        DatePicker("", selection: $dateLogged, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .tint(Theme.warmOrange)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
            .background(Theme.background)
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.textSecondary)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.primaryBrown)
                    .disabled(coffeeName.isEmpty)
                }
            }
        }
    }

    private func saveEntry() {
        // Compress photo if exists
        let compressedPhotoData = selectedPhoto?.compressed()

        let entry = CoffeeEntry(
            coffeeName: coffeeName,
            origin: origin,
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
