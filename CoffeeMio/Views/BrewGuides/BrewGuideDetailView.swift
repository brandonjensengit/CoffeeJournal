//
//  BrewGuideDetailView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/28/25.
//

import SwiftUI

struct BrewGuideDetailView: View {
    let guide: BrewGuide
    @Environment(\.colorScheme) private var colorScheme

    @State private var equipmentChecked: Set<UUID> = []
    @State private var stepsCompleted: Set<UUID> = []
    @State private var showTips = false
    @State private var showTroubleshooting = false
    @State private var selectedServings: Int

    init(guide: BrewGuide) {
        self.guide = guide
        self._selectedServings = State(initialValue: guide.servingInfo.baseServings)
    }

    private var scaledSteps: [BrewGuideStep] {
        guide.stepsForServings(selectedServings)
    }

    private var allStepsCompleted: Bool {
        stepsCompleted.count == guide.steps.count
    }

    private var progressPercentage: Double {
        guard !guide.steps.isEmpty else { return 0 }
        return Double(stepsCompleted.count) / Double(guide.steps.count)
    }

    private var scaledCoffee: Double {
        guide.servingInfo.scaledCoffee(for: selectedServings)
    }

    private var scaledWater: Double {
        guide.servingInfo.scaledWater(for: selectedServings)
    }

    private var scaledBloom: Double {
        guide.servingInfo.scaledBloom(for: selectedServings)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero section
                heroSection

                // Serving selector
                servingSelectorSection

                // Overview
                overviewSection

                // Quick stats
                quickStatsSection

                // Equipment checklist
                equipmentSection

                // Brewing steps
                brewingStepsSection

                // Tips & tricks
                tipsSection

                // Troubleshooting
                troubleshootingSection

                Spacer(minLength: 40)
            }
            .padding(.bottom, 20)
        }
        .background(Theme.background)
        .navigationTitle(guide.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack {
            Theme.coffeeGradient(for: colorScheme)
                .frame(height: 200)

            VStack(spacing: 12) {
                Image(systemName: guide.heroImage)
                    .font(.system(size: 80))
                    .foregroundStyle(.white.opacity(0.9))

                DifficultyBadge(difficulty: guide.difficulty)
                    .colorInvert()
            }
        }
    }

    // MARK: - Serving Selector Section

    private var servingSelectorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Servings")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)

            HStack(spacing: 0) {
                ForEach(guide.servingInfo.minServings...guide.servingInfo.maxServings, id: \.self) { serving in
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedServings = serving
                            // Reset completed steps when changing servings
                            stepsCompleted.removeAll()
                        }
                    }) {
                        Text("\(serving)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(selectedServings == serving ? .white : Theme.primaryBrown)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedServings == serving ? Theme.warmOrange : Theme.cardBackground)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.warmOrange.opacity(0.3), lineWidth: 1)
            )

            // Recipe summary
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Coffee")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textSecondary)
                    Text("\(Int(scaledCoffee))g")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Theme.primaryBrown)
                }

                Divider()
                    .frame(height: 30)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Water")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textSecondary)
                    Text("\(Int(scaledWater))g")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Theme.primaryBrown)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Ratio")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textSecondary)
                    Text(guide.quickStats.ratio)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(16)
            .background(Theme.warmOrange.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }

    // MARK: - Overview Section

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Theme.primaryBrown)

            Text(guide.fullDescription)
                .font(.system(size: 16))
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)
        }
        .padding(.horizontal)
    }

    // MARK: - Quick Stats Section

    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.primaryBrown)

            VStack(spacing: 12) {
                QuickStatRow(icon: "clock.fill", label: "Brew Time", value: guide.quickStats.brewTime)
                QuickStatRow(icon: "chart.bar.fill", label: "Difficulty", value: guide.quickStats.difficulty)
                QuickStatRow(icon: "circle.grid.3x3.fill", label: "Grind Size", value: guide.quickStats.grindSize)
                QuickStatRow(icon: "scalemass.fill", label: "Ratio", value: guide.quickStats.ratio)
                QuickStatRow(icon: "cup.and.saucer.fill", label: "Ideal For", value: guide.quickStats.idealFor)
                if let invented = guide.quickStats.invented {
                    QuickStatRow(icon: "calendar", label: "Invented", value: invented)
                }
            }
            .padding(16)
            .background(Theme.cardBackground)
            .cornerRadius(16)
        }
        .padding(.horizontal)
    }

    // MARK: - Equipment Section

    private var equipmentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What You'll Need")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.primaryBrown)

            VStack(spacing: 8) {
                ForEach(guide.equipment) { item in
                    EquipmentRow(
                        item: item,
                        isChecked: equipmentChecked.contains(item.id),
                        onToggle: {
                            if equipmentChecked.contains(item.id) {
                                equipmentChecked.remove(item.id)
                            } else {
                                equipmentChecked.insert(item.id)
                            }
                        }
                    )
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Brewing Steps Section

    private var brewingStepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Brewing Steps")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.primaryBrown)

                Spacer()

                // Progress indicator
                HStack(spacing: 8) {
                    Text("\(stepsCompleted.count)/\(guide.steps.count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)

                    if allStepsCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.warmOrange.opacity(0.2))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.warmOrange)
                        .frame(width: geometry.size.width * progressPercentage, height: 6)
                        .animation(.spring(response: 0.4), value: progressPercentage)
                }
            }
            .frame(height: 6)

            VStack(spacing: 16) {
                ForEach(scaledSteps) { step in
                    BrewStepRow(
                        step: step,
                        isCompleted: stepsCompleted.contains(step.id),
                        onToggle: {
                            if stepsCompleted.contains(step.id) {
                                stepsCompleted.remove(step.id)
                            } else {
                                stepsCompleted.insert(step.id)
                            }
                        }
                    )
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Tips Section

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: { withAnimation { showTips.toggle() } }) {
                HStack {
                    Text("Tips & Tricks")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Theme.primaryBrown)

                    Spacer()

                    Image(systemName: showTips ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .buttonStyle(PlainButtonStyle())

            if showTips {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(guide.tips.enumerated()), id: \.offset) { index, tip in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Theme.warmOrange)
                                .frame(width: 24)

                            Text(tip)
                                .font(.system(size: 15))
                                .foregroundStyle(Theme.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .cornerRadius(16)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Troubleshooting Section

    private var troubleshootingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: { withAnimation { showTroubleshooting.toggle() } }) {
                HStack {
                    Text("Troubleshooting")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Theme.primaryBrown)

                    Spacer()

                    Image(systemName: showTroubleshooting ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .buttonStyle(PlainButtonStyle())

            if showTroubleshooting {
                VStack(spacing: 12) {
                    ForEach(guide.troubleshooting) { item in
                        TroubleshootingRow(item: item)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Quick Stat Row

struct QuickStatRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.warmOrange)
                .frame(width: 24)

            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - Equipment Row

struct EquipmentRow: View {
    let item: EquipmentItem
    let isChecked: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isChecked ? .green : Theme.textSecondary.opacity(0.3))

                Image(systemName: item.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.warmOrange)
                    .frame(width: 24)

                Text(item.name)
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.primaryBrown)
                    .strikethrough(isChecked)

                if item.isOptional {
                    Text("(optional)")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                }

                Spacer()
            }
            .padding(12)
            .background(Theme.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Brew Step Row

struct BrewStepRow: View {
    let step: BrewGuideStep
    let isCompleted: Bool
    let onToggle: () -> Void

    @State private var timerCompleted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Step number / checkbox
                Button(action: onToggle) {
                    ZStack {
                        Circle()
                            .fill(isCompleted ? .green : Theme.warmOrange.opacity(0.2))
                            .frame(width: 32, height: 32)

                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                        } else {
                            Text("\(step.stepNumber)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Theme.warmOrange)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())

                VStack(alignment: .leading, spacing: 8) {
                    Text(step.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.primaryBrown)

                    Text(step.instruction)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    // Timer if step has one
                    if let duration = step.timerDuration, let label = step.timerLabel {
                        BrewTimerView(
                            duration: duration,
                            label: label,
                            isCompleted: $timerCompleted
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCompleted ? Color.green.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Troubleshooting Row

struct TroubleshootingRow: View {
    let item: TroubleshootingItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.orange)

                Text(item.problem)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.primaryBrown)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.green)

                Text(item.solution)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        BrewGuideDetailView(guide: BrewGuideProvider.shared.allGuides[0])
    }
}
