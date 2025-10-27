//
//  TastingNotesStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct TastingNotesStepView: View {
    @Binding var tastingNotes: [String]
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("What flavors did\nyou taste?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Subtitle
            Text("Select all that apply")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Theme.textSecondary)

            // Tasting notes selector
            ScrollView {
                TastingNotesSelector(selectedNotes: $tastingNotes)
                    .padding(.horizontal, 32)
            }
            .frame(maxHeight: 400)

            Spacer()

            // Next button
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Theme.primaryBrown)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}
