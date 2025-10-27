//
//  PhotoStepView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct PhotoStepView: View {
    @Binding var selectedImage: UIImage?
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Question
            Text("Add a photo?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryBrown)
                .multilineTextAlignment(.center)

            // Subtitle
            Text("Optional - capture the moment")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)

            // Photo content
            VStack(spacing: 24) {
                if let image = selectedImage {
                    // Show preview with remove button
                    ImagePreview(image: image) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedImage = nil
                        }
                    }
                    .padding(.horizontal, 32)
                } else {
                    // Show picker buttons
                    VStack(spacing: 16) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Theme.warmOrange.opacity(0.3))

                        ImagePicker(selectedImage: $selectedImage)
                            .padding(.horizontal, 32)
                    }
                }
            }

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
