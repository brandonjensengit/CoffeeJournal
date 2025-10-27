//
//  RoasterStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI
import SwiftData

struct RoasterStepView: View {
    @Binding var roaster: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("Who roasted it?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Roaster Picker
            RoasterPicker(selectedRoaster: $roaster)
                .padding(.horizontal, 32)

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
