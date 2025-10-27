//
//  TastingNotesSelector.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct TastingNotesSelector: View {
    @Binding var selectedNotes: [String]

    let commonTastingNotes = [
        "Chocolate", "Fruity", "Nutty", "Floral", "Caramel",
        "Citrus", "Berry", "Honey", "Spicy", "Earthy",
        "Sweet", "Bright", "Smooth", "Bold", "Balanced",
        "Creamy", "Crisp", "Complex", "Clean", "Juicy"
    ]

    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Selected notes
            if !selectedNotes.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedNotes, id: \.self) { note in
                            SelectedNoteChip(note: note) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedNotes.removeAll { $0 == note }
                                }
                            }
                        }
                    }
                }
            }

            // Available notes
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(commonTastingNotes.filter { !selectedNotes.contains($0) }, id: \.self) { note in
                    TastingNoteChip(note: note, isSelected: false)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedNotes.append(note)
                            }
                        }
                }
            }
        }
    }
}

struct TastingNoteChip: View {
    let note: String
    let isSelected: Bool

    var body: some View {
        Text(note)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(isSelected ? Theme.cream : Theme.primaryBrown)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Theme.primaryBrown : Theme.cream)
            )
            .overlay(
                Capsule()
                    .stroke(Theme.warmOrange.opacity(0.3), lineWidth: 1)
            )
    }
}

struct SelectedNoteChip: View {
    @Environment(\.colorScheme) private var colorScheme
    let note: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text(note)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.cream)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.cream.opacity(0.8))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Theme.primaryBrown)
        )
        .shadow(color: Theme.cardShadow(for: colorScheme), radius: 4, y: 2)
    }
}

#Preview {
    VStack {
        TastingNotesSelector(selectedNotes: .constant(["Chocolate", "Fruity", "Nutty"]))
            .padding()
    }
    .background(Theme.background)
}
