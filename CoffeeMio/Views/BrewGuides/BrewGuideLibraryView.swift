//
//  BrewGuideLibraryView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/28/25.
//

import SwiftUI

struct BrewGuideLibraryView: View {
    @State private var searchText = ""
    @State private var guideProvider = BrewGuideProvider.shared

    private var filteredGuides: [BrewGuide] {
        if searchText.isEmpty {
            return guideProvider.allGuides
        } else {
            return guideProvider.allGuides.filter { guide in
                guide.name.localizedCaseInsensitiveContains(searchText) ||
                guide.shortDescription.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Brew Guides")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.primaryBrown)

                        Text("Master your brewing techniques")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Theme.textSecondary)

                        TextField("Search brew methods...", text: $searchText)
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.primaryBrown)
                    }
                    .padding(12)
                    .background(Theme.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Grid of brew method cards
                    if filteredGuides.isEmpty {
                        // Empty state
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))

                            Text("No brew guides found")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary)

                            Text("Try a different search term")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(filteredGuides) { guide in
                                NavigationLink(destination: BrewGuideDetailView(guide: guide)) {
                                    BrewGuideCard(guide: guide)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.bottom, 20)
            }
            .background(Theme.background)
        }
    }
}

#Preview {
    BrewGuideLibraryView()
}
