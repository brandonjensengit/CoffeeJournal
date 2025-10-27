//
//  PersonalNotesStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct PersonalNotesStepView: View {
    @Binding var personalNotes: String
    let onNext: () -> Void

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("Any thoughts or\nobservations?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Subtitle
            Text("Optional - capture your experience")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)

            // Text editor
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $personalNotes)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(Theme.primaryBrown)
                        .scrollContentBackground(.hidden)
                        .background(Theme.cardBackground)
                        .cornerRadius(16)
                        .frame(height: 200)
                        .focused($isTextFieldFocused)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isTextFieldFocused ? Theme.warmOrange : Theme.warmOrange.opacity(0.2), lineWidth: 2)
                        )

                    if personalNotes.isEmpty && !isTextFieldFocused {
                        Text("E.g., Perfect morning brew, pairs well with pastries...")
                            .font(.system(size: 18))
                            .foregroundStyle(Theme.textSecondary.opacity(0.5))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
            }
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
        .onAppear {
            // Small delay to allow transition to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTextFieldFocused = true
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isTextFieldFocused = false
                }
                .foregroundStyle(Theme.primaryBrown)
                .fontWeight(.semibold)
            }
        }
    }
}
