//
//  MainTabView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/28/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            // Brew Guides Tab
            BrewGuideLibraryView()
                .tabItem {
                    Label("Guides", systemImage: "book.fill")
                }
                .tag(1)
        }
        .tint(Theme.warmOrange)
    }
}

#Preview {
    MainTabView()
}
