//
//  EditEntryView.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct EditEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var entry: CoffeeEntry

    @State private var temperatureManager = TemperatureManager.shared
    @State private var selectedPhoto: UIImage?
    @State private var photoChanged = false
    @State private var isDetailedMode = true
    @State private var displayTemperature: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacingL) {
                    // Coffee Info Section
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Coffee Details", icon: "cup.and.saucer.fill")

                        CustomTextField(title: "Coffee Name", text: $entry.coffeeName, placeholder: "e.g., Ethiopian Yirgacheffe")
                        CustomTextField(title: "Origin", text: $entry.origin, placeholder: "e.g., Ethiopia")
                        RoasterPicker(selectedRoaster: $entry.roaster)
                    }
                    .padding(.horizontal)

                    // Brew Method
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Brew Method", icon: "drop.fill")
                        BrewMethodPicker(selectedMethod: $entry.brewMethod)
                    }
                    .padding(.horizontal)

                    // Roast Level
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Roast Level", icon: "flame.fill")
                        RoastLevelIndicator(selectedLevel: $entry.roastLevel)
                    }
                    .padding(.horizontal)

                    // Grind Size
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Grind Size", icon: "circle.grid.3x3.fill")
                        GrindSizeSlider(grindSize: $entry.grindSize)
                    }
                    .padding(.horizontal)

                    // Brew Parameters
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Brew Parameters", icon: "chart.bar.fill")

                        HStack(spacing: Theme.spacingM) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Coffee (g)")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                TextField("18", value: $entry.coffeeGrams, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Water (g)")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                TextField("300", value: $entry.waterGrams, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Water Temp (\(temperatureManager.selectedUnit.symbol))")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)

                            HStack {
                                Slider(value: $displayTemperature, in: temperatureManager.sliderRange(), step: 1)
                                    .tint(Theme.warmOrange)
                                    .onChange(of: displayTemperature) { _, newValue in
                                        entry.waterTemperature = temperatureManager.toCelsius(newValue)
                                    }

                                Text("\(Int(displayTemperature))\(temperatureManager.selectedUnit.symbol)")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Theme.primaryBrown)
                                    .frame(width: 60)
                            }
                        }
                        .onAppear {
                            displayTemperature = temperatureManager.displayValue(entry.waterTemperature)
                        }

                        HStack(spacing: Theme.spacingM) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Brew Time")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                HStack {
                                    TextField("3", value: $entry.brewTimeMinutes, format: .number)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .frame(width: 60)

                                    Text("m")
                                        .foregroundStyle(Theme.textSecondary)

                                    TextField("30", value: $entry.brewTimeSeconds, format: .number)
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

                    // Rating
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Rating", icon: "star.fill")
                        RatingView(rating: $entry.rating, interactive: true)
                    }
                    .padding(.horizontal)

                    // Tasting Notes
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Tasting Notes", icon: "nose.fill")
                        TastingNotesSelector(selectedNotes: $entry.tastingNotes)
                    }
                    .padding(.horizontal)

                    // Personal Notes
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Personal Notes", icon: "note.text")

                        TextEditor(text: $entry.personalNotes)
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
                                photoChanged = true
                            }
                        } else {
                            ImagePicker(selectedImage: $selectedPhoto)
                        }
                    }
                    .padding(.horizontal)
                    .onChange(of: selectedPhoto) { _, newValue in
                        if newValue != nil {
                            photoChanged = true
                        }
                    }

                    // Date
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        SectionHeader(title: "Date", icon: "calendar")

                        DatePicker("", selection: $entry.dateLogged, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .tint(Theme.warmOrange)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
            .background(Theme.background)
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // Load existing photo if available
                if let photoData = entry.photoData,
                   let uiImage = UIImage(data: photoData) {
                    selectedPhoto = uiImage
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.textSecondary)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveChanges()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.primaryBrown)
                }
            }
        }
    }

    private func saveChanges() {
        // Update photo data if changed
        if photoChanged {
            entry.photoData = selectedPhoto?.compressed()
        }
    }
}
