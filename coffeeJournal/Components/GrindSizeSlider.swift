//
//  GrindSizeSlider.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct GrindSizeSlider: View {
    @Binding var grindSize: Double // 1.0 to 10.0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Fine")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)

                Spacer()

                Text(grindLabel)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Theme.primaryBrown)

                Spacer()

                Text("Coarse")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }

            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(Theme.cream)
                    .frame(height: 8)

                // Active track
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Theme.warmOrange, Theme.goldenBrown],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: trackWidth, height: 8)

                // Visual grind particles
                HStack(spacing: 0) {
                    ForEach(1...10, id: \.self) { index in
                        Circle()
                            .fill(grindSize >= Double(index) ? Theme.darkBrown : Theme.cream)
                            .frame(width: particleSize(for: index), height: particleSize(for: index))
                            .frame(maxWidth: .infinity)
                    }
                }
            }

            // Custom slider
            Slider(value: $grindSize, in: 1...10, step: 0.5)
                .tint(Theme.warmOrange)
        }
    }

    private var grindLabel: String {
        switch grindSize {
        case 1.0..<2.5: return "Extra Fine"
        case 2.5..<4.5: return "Fine"
        case 4.5..<6.5: return "Medium"
        case 6.5..<8.5: return "Coarse"
        default: return "Extra Coarse"
        }
    }

    private var trackWidth: CGFloat {
        let percentage = (grindSize - 1.0) / 9.0
        return UIScreen.main.bounds.width * 0.85 * percentage
    }

    private func particleSize(for index: Int) -> CGFloat {
        let baseSize: CGFloat = 4
        let maxSize: CGFloat = 12
        let increment = (maxSize - baseSize) / 9
        return baseSize + (CGFloat(index - 1) * increment)
    }
}

#Preview {
    VStack {
        GrindSizeSlider(grindSize: .constant(5.0))
            .padding()
    }
    .background(Theme.background)
}
