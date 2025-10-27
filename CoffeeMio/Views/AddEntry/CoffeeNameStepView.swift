//
//  CoffeeNameStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct CoffeeNameStepView: View {
    @Binding var coffeeName: String
    let onNext: () -> Void

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("What coffee are you\nbrewing today?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Input field
            TextField("e.g., Ethiopian Yirgacheffe", text: $coffeeName)
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(20)
                .background(Theme.cardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.warmOrange.opacity(0.3), lineWidth: 2)
                )
                .padding(.horizontal, 32)
                .focused($isTextFieldFocused)
                .submitLabel(.next)
                .onSubmit {
                    if !coffeeName.isEmpty {
                        onNext()
                    }
                }

            Spacer()

            // Next button
            Button(action: {
                isTextFieldFocused = false
                onNext()
            }) {
                Text("Next")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        coffeeName.isEmpty ? Theme.textSecondary : Theme.primaryBrown
                    )
                    .cornerRadius(16)
            }
            .disabled(coffeeName.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
}
