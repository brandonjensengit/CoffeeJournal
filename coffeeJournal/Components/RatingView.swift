//
//  RatingView.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Double
    let maximumRating: Int = 5
    let interactive: Bool

    init(rating: Binding<Double>, interactive: Bool = true) {
        self._rating = rating
        self.interactive = interactive
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maximumRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .font(.system(size: 24))
                    .foregroundStyle(starColor(for: index))
                    .onTapGesture {
                        if interactive {
                            withAnimation(.spring(response: 0.3)) {
                                rating = Double(index)
                            }
                        }
                    }
            }
        }
    }

    private func starType(for position: Int) -> String {
        let difference = rating - Double(position - 1)

        if difference >= 1.0 {
            return "star.fill"
        } else if difference >= 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }

    private func starColor(for position: Int) -> Color {
        return rating >= Double(position - 1) + 0.5 ? Theme.warmOrange : Theme.textSecondary.opacity(0.3)
    }
}

#Preview {
    VStack(spacing: 20) {
        RatingView(rating: .constant(4.5), interactive: true)
        RatingView(rating: .constant(3.0), interactive: true)
        RatingView(rating: .constant(5.0), interactive: false)
    }
    .padding()
}
