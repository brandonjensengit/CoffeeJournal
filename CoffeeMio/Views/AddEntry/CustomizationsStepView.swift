//
//  CustomizationsStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/27/25.
//

import SwiftUI

struct CustomizationsStepView: View {
    @Binding var customizations: CoffeeCustomizations?
    let onNext: () -> Void

    @State private var showingCustomizer = false

    var body: some View {
        if showingCustomizer {
            CustomizationFormView(customizations: $customizations, onDone: onNext)
        } else {
            CustomizationChoiceView(
                onKeepPure: {
                    customizations = nil
                    onNext()
                },
                onCustomize: {
                    if customizations == nil {
                        customizations = CoffeeCustomizations()
                    }
                    withAnimation(.spring(response: 0.4)) {
                        showingCustomizer = true
                    }
                }
            )
        }
    }
}

// MARK: - Initial Choice View

struct CustomizationChoiceView: View {
    let onKeepPure: () -> Void
    let onCustomize: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("Keep it pure or customize?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            Text("Add milk, sweeteners, or other touches")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                // Keep Pure button
                Button(action: onKeepPure) {
                    HStack(spacing: 12) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primaryBrown)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Keep it Pure")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Theme.primaryBrown)

                            Text("Black coffee, no additions")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.textSecondary)
                        }

                        Spacer()
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Theme.cardBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.warmOrange.opacity(0.3), lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Customize button
                Button(action: onCustomize) {
                    HStack(spacing: 12) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.warmOrange)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Customize")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Theme.primaryBrown)

                            Text("Add milk, sweeteners, or flavors")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.textSecondary)
                        }

                        Spacer()
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Theme.cardBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.warmOrange, lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }
}

// MARK: - Customization Form View

struct CustomizationFormView: View {
    @Binding var customizations: CoffeeCustomizations?
    let onDone: () -> Void

    @State private var hasMilk = false
    @State private var milkType: MilkType = .whole
    @State private var milkAmount = "Splash"
    @State private var milkTemp: MilkTemperature? = nil
    @State private var foamLevel: FoamLevel? = nil

    @State private var sweeteners: [Sweetener] = []
    @State private var flavors: [Flavor] = []
    @State private var selectedSpices: Set<String> = []
    @State private var hasWhippedCream = false
    @State private var iceAmount: IceAmount? = nil

    let commonSpices = ["Cinnamon", "Nutmeg", "Cardamom", "Cocoa Powder", "Vanilla Extract"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Customizations")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.primaryBrown)

                    Text("Optional additions to your brew")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Milk Section
                VStack(alignment: .leading, spacing: 16) {
                    Toggle(isOn: $hasMilk) {
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundStyle(Theme.warmOrange)
                            Text("Add Milk")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Theme.primaryBrown)
                        }
                    }
                    .tint(Theme.warmOrange)

                    if hasMilk {
                        VStack(alignment: .leading, spacing: 12) {
                            // Milk Type
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Type")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(MilkType.allCases, id: \.self) { type in
                                            SelectableChip(
                                                label: type.rawValue,
                                                isSelected: milkType == type,
                                                action: { milkType = type }
                                            )
                                        }
                                    }
                                }
                            }

                            // Milk Amount
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Amount")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                HStack(spacing: 8) {
                                    ForEach(["Splash", "1:1", "2:1"], id: \.self) { amount in
                                        SelectableChip(
                                            label: amount,
                                            isSelected: milkAmount == amount,
                                            action: { milkAmount = amount }
                                        )
                                    }
                                }
                            }

                            // Temperature (optional)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Temperature (optional)")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(MilkTemperature.allCases, id: \.self) { temp in
                                            SelectableChip(
                                                label: temp.rawValue,
                                                isSelected: milkTemp == temp,
                                                action: {
                                                    milkTemp = (milkTemp == temp) ? nil : temp
                                                }
                                            )
                                        }
                                    }
                                }
                            }

                            // Foam Level (optional)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Foam (optional)")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)

                                HStack(spacing: 8) {
                                    ForEach(FoamLevel.allCases, id: \.self) { foam in
                                        SelectableChip(
                                            label: foam.rawValue,
                                            isSelected: foamLevel == foam,
                                            action: {
                                                foamLevel = (foamLevel == foam) ? nil : foam
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.leading, 32)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Theme.cardBackground)
                .cornerRadius(16)
                .padding(.horizontal)

                // Sweetener Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "cube.fill")
                            .foregroundStyle(Theme.warmOrange)
                        Text("Sweeteners")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.primaryBrown)

                        Spacer()

                        Button(action: {
                            sweeteners.append(Sweetener())
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Theme.warmOrange)
                        }
                    }

                    if !sweeteners.isEmpty {
                        ForEach(Array(sweeteners.enumerated()), id: \.offset) { index, sweetener in
                            HStack(spacing: 12) {
                                Picker("Type", selection: Binding(
                                    get: { sweeteners[index].type },
                                    set: { sweeteners[index].type = $0 }
                                )) {
                                    ForEach(SweetenerType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Theme.primaryBrown)

                                TextField("Amount", text: Binding(
                                    get: { sweeteners[index].amount },
                                    set: { sweeteners[index].amount = $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)

                                Button(action: {
                                    sweeteners.remove(at: index)
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Theme.cardBackground)
                .cornerRadius(16)
                .padding(.horizontal)

                // Flavors Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(Theme.warmOrange)
                        Text("Flavors & Syrups")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.primaryBrown)

                        Spacer()

                        Button(action: {
                            flavors.append(Flavor())
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Theme.warmOrange)
                        }
                    }

                    if !flavors.isEmpty {
                        ForEach(Array(flavors.enumerated()), id: \.offset) { index, flavor in
                            HStack(spacing: 12) {
                                Picker("Type", selection: Binding(
                                    get: { flavors[index].type },
                                    set: { flavors[index].type = $0 }
                                )) {
                                    ForEach(FlavorType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Theme.primaryBrown)

                                TextField("Amount", text: Binding(
                                    get: { flavors[index].amount },
                                    set: { flavors[index].amount = $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)

                                Button(action: {
                                    flavors.remove(at: index)
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Theme.cardBackground)
                .cornerRadius(16)
                .padding(.horizontal)

                // Spices & Extras
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(Theme.warmOrange)
                        Text("Spices & Extras")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.primaryBrown)
                    }

                    // Spices
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spices")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)

                        FlowLayout(spacing: 8) {
                            ForEach(commonSpices, id: \.self) { spice in
                                SelectableChip(
                                    label: spice,
                                    isSelected: selectedSpices.contains(spice),
                                    action: {
                                        if selectedSpices.contains(spice) {
                                            selectedSpices.remove(spice)
                                        } else {
                                            selectedSpices.insert(spice)
                                        }
                                    }
                                )
                            }
                        }
                    }

                    // Whipped Cream
                    Toggle(isOn: $hasWhippedCream) {
                        Text("Whipped Cream")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.primaryBrown)
                    }
                    .tint(Theme.warmOrange)

                    // Ice Amount
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ice (optional)")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)

                        HStack(spacing: 8) {
                            ForEach([nil] + IceAmount.allCases.map { $0 as IceAmount? }, id: \.self) { amount in
                                SelectableChip(
                                    label: amount?.rawValue ?? "None",
                                    isSelected: iceAmount == amount,
                                    action: { iceAmount = amount }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Theme.cardBackground)
                .cornerRadius(16)
                .padding(.horizontal)

                // Done Button
                Button(action: saveAndContinue) {
                    Text("Done")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Theme.primaryBrown)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            loadExistingCustomizations()
        }
    }

    private func loadExistingCustomizations() {
        guard let customs = customizations else { return }

        if let milk = customs.milk {
            hasMilk = true
            milkType = milk.type
            milkAmount = milk.amount
            milkTemp = milk.temperature
            foamLevel = milk.foamLevel
        }

        sweeteners = customs.sweeteners
        flavors = customs.flavors
        selectedSpices = Set(customs.spices)
        hasWhippedCream = customs.hasWhippedCream
        iceAmount = customs.iceAmount
    }

    private func saveAndContinue() {
        let milk = hasMilk ? MilkCustomization(
            type: milkType,
            amount: milkAmount,
            temperature: milkTemp,
            foamLevel: foamLevel
        ) : nil

        customizations = CoffeeCustomizations(
            milk: milk,
            sweeteners: sweeteners,
            flavors: flavors,
            spices: Array(selectedSpices),
            hasWhippedCream: hasWhippedCream,
            iceAmount: iceAmount
        )

        onDone()
    }
}

// MARK: - Selectable Chip Component

struct SelectableChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? .white : Theme.primaryBrown)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.warmOrange : Theme.cream)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Theme.warmOrange : Theme.warmOrange.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
