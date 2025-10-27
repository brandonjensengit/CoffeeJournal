//
//  HomeView.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CoffeeEntry.dateLogged, order: .reverse) private var entries: [CoffeeEntry]

    @State private var showingAddEntry = false
    @State private var showingSettings = false
    @State private var searchText = ""
    @State private var selectedBrewMethod: BrewMethod?
    @State private var showingFilters = false

    var filteredEntries: [CoffeeEntry] {
        var result = entries

        // Search filter
        if !searchText.isEmpty {
            result = result.filter { entry in
                entry.coffeeName.localizedCaseInsensitiveContains(searchText) ||
                entry.origin.localizedCaseInsensitiveContains(searchText) ||
                entry.roaster.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Brew method filter
        if let method = selectedBrewMethod {
            result = result.filter { $0.brewMethod == method }
        }

        return result
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if entries.isEmpty {
                    EmptyStateView(showingAddEntry: $showingAddEntry)
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.spacingM) {
                            ForEach(filteredEntries) { entry in
                                NavigationLink(destination: EntryDetailView(entry: entry)) {
                                    CoffeeEntryCard(entry: entry)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Coffee Journal")
            .searchable(text: $searchText, prompt: "Search coffees...")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button(action: { selectedBrewMethod = nil }) {
                            Label("All Methods", systemImage: selectedBrewMethod == nil ? "checkmark" : "")
                        }

                        Divider()

                        ForEach(BrewMethod.allCases, id: \.self) { method in
                            Button(action: { selectedBrewMethod = method }) {
                                Label(method.rawValue, systemImage: selectedBrewMethod == method ? "checkmark" : method.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(Theme.primaryBrown)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: { showingSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Theme.primaryBrown)
                        }

                        Button(action: { showingAddEntry = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Theme.warmOrange, Theme.goldenBrown],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

// MARK: - Coffee Entry Card

struct CoffeeEntryCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let entry: CoffeeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with image/gradient
            ZStack(alignment: .topTrailing) {
                if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 160)
                        .clipped()
                } else {
                    Theme.coffeeGradient(for: colorScheme)
                        .frame(height: 160)
                        .overlay(
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(Theme.cream.opacity(0.3))
                        )
                }

                // Favorite badge
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.warmOrange)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(Theme.cardBackground.opacity(0.9))
                        )
                        .padding(12)
                }
            }

            // Content
            VStack(alignment: .leading, spacing: Theme.spacingS) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.coffeeName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(2)

                        if !entry.origin.isEmpty {
                            Text(entry.origin)
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Image(systemName: entry.brewMethod.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(Theme.warmOrange)

                        Text(entry.brewMethod.rawValue)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }

                // Rating
                HStack(spacing: 6) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: entry.rating >= Double(index) ? "star.fill" : "star")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.warmOrange)
                    }

                    Text(String(format: "%.1f", entry.rating))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                }

                // Roaster
                if !entry.roaster.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)

                        Text(entry.roaster)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }

                // Tasting notes preview
                if !entry.tastingNotes.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(entry.tastingNotes.prefix(3), id: \.self) { note in
                                Text(note)
                                    .font(.caption)
                                    .foregroundStyle(Theme.primaryBrown)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Theme.cream)
                                    )
                            }
                        }
                    }
                }

                // Date
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)

                    Text(entry.dateLogged.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)

                    Spacer()

                    Text(entry.dateLogged.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(Theme.spacingM)
            .background(Theme.cardBackground)
        }
        .cornerRadius(Theme.cornerRadiusLarge)
        .shadow(color: Theme.cardShadow(for: colorScheme), radius: 8, y: 4)
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showingAddEntry: Bool

    var body: some View {
        VStack(spacing: Theme.spacingL) {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.warmOrange, Theme.goldenBrown],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: Theme.spacingS) {
                Text("Start Your Coffee Journey")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)

                Text("Log your first coffee brewing session\nand start tracking your favorites")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: { showingAddEntry = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))

                    Text("Add Your First Coffee")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundStyle(Theme.cream)
                .padding(.horizontal, Theme.spacingL)
                .padding(.vertical, Theme.spacingM)
                .background(
                    Capsule()
                        .fill(Theme.primaryBrown)
                )
                .shadow(color: Theme.cardShadow(for: colorScheme), radius: 8, y: 4)
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
        .modelContainer(for: CoffeeEntry.self, inMemory: true)
}
