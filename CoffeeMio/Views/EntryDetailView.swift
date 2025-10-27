//
//  EntryDetailView.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @Bindable var entry: CoffeeEntry
    @State private var temperatureManager = TemperatureManager.shared

    @State private var showingDeleteAlert = false
    @State private var showingEditView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                } else {
                    ZStack {
                        Theme.coffeeGradient(for: colorScheme)
                            .frame(height: 300)

                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 100))
                            .foregroundStyle(Theme.cream.opacity(0.3))
                    }
                }

                VStack(alignment: .leading, spacing: Theme.spacingL) {
                    // Title & Basic Info
                    VStack(alignment: .leading, spacing: Theme.spacingS) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.coffeeName)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(Theme.textPrimary)

                                if !entry.origin.isEmpty {
                                    Text(entry.origin)
                                        .font(.system(size: 18))
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }

                            Spacer()

                            Button(action: { entry.isFavorite.toggle() }) {
                                Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Theme.warmOrange)
                            }
                        }

                        if !entry.roaster.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "building.2.fill")
                                    .foregroundStyle(Theme.warmOrange)

                                Text(entry.roaster)
                                    .font(.system(size: 16))
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }

                        // Rating
                        VStack(alignment: .leading, spacing: 8) {
                            RatingView(rating: .constant(entry.rating), interactive: false)

                            Text(String(format: "%.1f / 5.0", entry.rating))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }

                    Divider()

                    // Brew Method & Roast Level
                    HStack(spacing: Theme.spacingL) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Brew Method", systemImage: "drop.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)

                            HStack(spacing: 8) {
                                Image(systemName: entry.brewMethod.icon)
                                    .font(.system(size: 24))
                                    .foregroundStyle(Theme.warmOrange)

                                Text(entry.brewMethod.rawValue)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Theme.textPrimary)
                            }
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Roast Level", systemImage: "flame.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)

                            HStack(spacing: 8) {
                                Circle()
                                    .fill(roastColor(entry.roastLevel))
                                    .frame(width: 24, height: 24)

                                Text(entry.roastLevel.rawValue)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Theme.textPrimary)
                            }
                        }
                    }

                    Divider()

                    // Brew Parameters
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        Text("Brew Parameters")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Theme.textPrimary)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.spacingM) {
                            ParameterCard(icon: "scalemass.fill", label: "Coffee", value: "\(Int(entry.coffeeGrams))g")
                            ParameterCard(icon: "drop.fill", label: "Water", value: "\(Int(entry.waterGrams))g")
                            ParameterCard(icon: "chart.line.uptrend.xyaxis", label: "Ratio", value: entry.brewRatio)
                            ParameterCard(icon: "thermometer", label: "Temperature", value: temperatureManager.displayTemperature(entry.waterTemperature))
                            ParameterCard(icon: "clock.fill", label: "Brew Time", value: entry.totalBrewTime)
                            ParameterCard(icon: "circle.grid.3x3.fill", label: "Grind", value: grindLabel(entry.grindSize))
                        }
                    }

                    Divider()

                    // Tasting Notes
                    if !entry.tastingNotes.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            Text("Tasting Notes")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Theme.textPrimary)

                            FlowLayout(spacing: 8) {
                                ForEach(entry.tastingNotes, id: \.self) { note in
                                    Text(note)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Theme.primaryBrown)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(Theme.cream)
                                        )
                                }
                            }
                        }

                        Divider()
                    }

                    // Personal Notes
                    if !entry.personalNotes.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            Text("Personal Notes")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Theme.textPrimary)

                            Text(entry.personalNotes)
                                .font(.system(size: 16))
                                .foregroundStyle(Theme.textSecondary)
                                .padding(Theme.spacingM)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.cream)
                                .cornerRadius(Theme.cornerRadiusMedium)
                        }

                        Divider()
                    }

                    // Date
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(Theme.warmOrange)

                        Text(entry.dateLogged.formatted(date: .long, time: .shortened))
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding()
            }
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { showingEditView = true }) {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(Theme.primaryBrown)
                }
            }
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
        } message: {
            Text("Are you sure you want to delete this coffee entry? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            EditEntryView(entry: entry)
        }
    }

    private func deleteEntry() {
        modelContext.delete(entry)
        dismiss()
    }

    private func roastColor(_ level: RoastLevel) -> Color {
        switch level {
        case .light: return Theme.roastLight
        case .medium: return Theme.roastMedium
        case .mediumDark: return Theme.roastMediumDark
        case .dark: return Theme.roastDark
        }
    }

    private func grindLabel(_ size: Double) -> String {
        switch size {
        case 1.0..<2.5: return "Extra Fine"
        case 2.5..<4.5: return "Fine"
        case 4.5..<6.5: return "Medium"
        case 6.5..<8.5: return "Coarse"
        default: return "Extra Coarse"
        }
    }
}

// MARK: - Parameter Card

struct ParameterCard: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(Theme.warmOrange)

            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.cream)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
}

// MARK: - Flow Layout for Tasting Notes

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    NavigationStack {
        EntryDetailView(entry: CoffeeEntry(
            coffeeName: "Ethiopian Yirgacheffe",
            origin: "Ethiopia",
            roaster: "Blue Bottle",
            brewMethod: .pourOver,
            roastLevel: .light,
            rating: 4.5,
            tastingNotes: ["Floral", "Citrus", "Bright"],
            personalNotes: "Amazing complexity with jasmine and bergamot notes."
        ))
    }
    .modelContainer(for: CoffeeEntry.self, inMemory: true)
}
