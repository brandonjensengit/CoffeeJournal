//
//  WispShape.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct WispShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Bottom of wisp (narrow)
        path.move(to: CGPoint(x: width * 0.5, y: height))

        // Left side curve (widens as it goes up)
        path.addQuadCurve(
            to: CGPoint(x: width * 0.2, y: height * 0.6),
            control: CGPoint(x: width * 0.3, y: height * 0.8)
        )

        path.addQuadCurve(
            to: CGPoint(x: width * 0.3, y: height * 0.2),
            control: CGPoint(x: width * 0.1, y: height * 0.4)
        )

        // Top curve (organic rounded top)
        path.addQuadCurve(
            to: CGPoint(x: width * 0.7, y: height * 0.2),
            control: CGPoint(x: width * 0.5, y: height * 0.0)
        )

        // Right side curve
        path.addQuadCurve(
            to: CGPoint(x: width * 0.8, y: height * 0.6),
            control: CGPoint(x: width * 0.9, y: height * 0.4)
        )

        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control: CGPoint(x: width * 0.7, y: height * 0.8)
        )

        path.closeSubpath()
        return path
    }
}
