//
//  coffeeJournalApp.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI
import SwiftData

@main
struct CoffeeMioApp: App {
    @State private var appearanceManager = AppearanceManager.shared

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CoffeeEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        // Apply saved appearance preference on app launch
        AppearanceManager.shared.applyAppearance()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
