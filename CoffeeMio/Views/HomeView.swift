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
                        .padding(.top, 40) // Extra top padding to clear large logo
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search coffees...")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("CoffeeMioLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 110)
                        .padding(.top, 8)
                }

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
    @State private var cupOpacity: Double = 0
    @State private var cupScale: Double = 0.8

    var body: some View {
        VStack(spacing: Theme.spacingL) {
            ZStack {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.warmOrange, Theme.goldenBrown],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(cupOpacity)
                    .scaleEffect(cupScale)

                SteamView()
                    .offset(y: -50)
                    .opacity(cupOpacity)
            }
            .onAppear {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.6)) {
                    cupOpacity = 1.0
                    cupScale = 1.0
                }
            }

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

// MARK: - Steam Animation

struct SteamView: View {
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                HomeSteamWisp(index: index, totalCount: 6, baseOpacity: 0.5)
                    .id("home-steam-\(index)")
            }
        }
    }
}

struct HomeSteamWisp: View {
    @Environment(\.colorScheme) private var colorScheme
    let index: Int
    let totalCount: Int
    let baseOpacity: Double

    // Animation state
    @State private var yOffset: Double = 0
    @State private var xOffset: Double = 0
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.3
    @State private var rotation: Double = 0
    @State private var hasStartedAnimating = false

    // Random variations for natural look
    let initialXOffset: Double
    let duration: Double
    let maxSway: Double
    let rotationAmount: Double
    let wispWidth: CGFloat
    let wispHeight: CGFloat
    let blurRadius: CGFloat

    init(index: Int, totalCount: Int, baseOpacity: Double) {
        self.index = index
        self.totalCount = totalCount
        self.baseOpacity = baseOpacity

        // Generate random variations for natural appearance
        self.initialXOffset = Double.random(in: -15...15)
        self.duration = Double.random(in: 3.5...5.0)
        self.maxSway = Double.random(in: 15...25)
        self.rotationAmount = Double.random(in: -10...10)
        self.wispWidth = CGFloat.random(in: 12...20)
        self.wispHeight = CGFloat.random(in: 30...50)
        self.blurRadius = CGFloat.random(in: 10...15)
    }

    var steamColor: Color {
        // Make steam darker and more visible in light mode
        colorScheme == .dark ? Color.white : Color.gray
    }

    var body: some View {
        // Organic wispy shape
        WispShape()
            .fill(
                LinearGradient(
                    colors: [
                        steamColor.opacity(1.0),
                        steamColor.opacity(0.6),
                        steamColor.opacity(0.0)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: wispWidth, height: wispHeight)
            .blur(radius: blurRadius)
            .shadow(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.3), radius: 3)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                guard !hasStartedAnimating else { return }
                hasStartedAnimating = true

                let delay = Double(index) * 0.5

                // Rising motion with ease-out
                withAnimation(
                    .easeOut(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    yOffset = -80
                    opacity = 0
                    scale = 2.0
                }

                // Horizontal sway with sine wave
                withAnimation(
                    .easeInOut(duration: duration * 0.6)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    xOffset = initialXOffset + maxSway
                }

                // Rotation
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    rotation = rotationAmount
                }

                // Initial fade in
                withAnimation(
                    .easeIn(duration: 0.5)
                    .delay(delay)
                ) {
                    opacity = baseOpacity
                }
            }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: CoffeeEntry.self, inMemory: true)
}
