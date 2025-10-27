//
//  RoasterPicker.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI
import SwiftData

struct RoasterPicker: View {
    @Query(sort: \CoffeeEntry.roaster) var entries: [CoffeeEntry]
    @Binding var selectedRoaster: String

    @State private var showingAddNew = false
    @State private var newRoasterName = ""

    var uniqueRoasters: [String] {
        let roasters = Set(entries.map { $0.roaster }.filter { !$0.isEmpty })
        return roasters.sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Roaster")
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)

            Menu {
                // Clear selection option (if roaster is selected)
                if !selectedRoaster.isEmpty {
                    Button(role: .destructive) {
                        selectedRoaster = ""
                    } label: {
                        Label("Clear Selection", systemImage: "xmark.circle")
                    }

                    Divider()
                }

                // List of saved roasters
                if !uniqueRoasters.isEmpty {
                    ForEach(uniqueRoasters, id: \.self) { roaster in
                        Button {
                            selectedRoaster = roaster
                        } label: {
                            HStack {
                                Text(roaster)
                                if selectedRoaster == roaster {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }

                    Divider()
                }

                // Add new roaster option
                Button {
                    showingAddNew = true
                    newRoasterName = ""
                } label: {
                    Label("Add New Roaster...", systemImage: "plus.circle")
                }
            } label: {
                HStack {
                    Image(systemName: "building.2.fill")
                        .foregroundStyle(Theme.warmOrange)
                        .font(.system(size: 18))

                    Text(selectedRoaster.isEmpty ? "Select Roaster" : selectedRoaster)
                        .foregroundStyle(selectedRoaster.isEmpty ? Theme.textSecondary : Theme.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding()
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadiusMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                        .stroke(Theme.cream, lineWidth: 1)
                )
            }
        }
        .alert("Add New Roaster", isPresented: $showingAddNew) {
            TextField("Roaster Name", text: $newRoasterName)

            Button("Cancel", role: .cancel) {
                newRoasterName = ""
            }

            Button("Add") {
                if !newRoasterName.isEmpty {
                    selectedRoaster = newRoasterName
                    newRoasterName = ""
                }
            }
        } message: {
            Text("Enter the name of the roaster")
        }
    }
}

#Preview {
    @Previewable @State var roaster = ""

    RoasterPicker(selectedRoaster: $roaster)
        .padding()
        .modelContainer(for: CoffeeEntry.self, inMemory: true)
}
