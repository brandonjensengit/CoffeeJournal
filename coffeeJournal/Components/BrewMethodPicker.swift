//
//  BrewMethodPicker.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct BrewMethodPicker: View {
    @Binding var selectedMethod: BrewMethod

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(BrewMethod.allCases, id: \.self) { method in
                BrewMethodCard(
                    method: method,
                    isSelected: selectedMethod == method
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) {
                        selectedMethod = method
                    }
                }
            }
        }
    }
}

struct BrewMethodCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let method: BrewMethod
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: method.icon)
                .font(.system(size: 28))
                .foregroundStyle(isSelected ? Theme.cream : Theme.primaryBrown)

            Text(method.rawValue)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(isSelected ? Theme.cream : Theme.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                .fill(isSelected ? Theme.primaryBrown : Theme.cream)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                .stroke(isSelected ? Theme.warmOrange : Color.clear, lineWidth: 2)
        )
        .shadow(color: Theme.cardShadow(for: colorScheme), radius: isSelected ? 8 : 4, y: 2)
    }
}

#Preview {
    VStack {
        BrewMethodPicker(selectedMethod: .constant(.pourOver))
            .padding()
    }
    .background(Theme.background)
}
