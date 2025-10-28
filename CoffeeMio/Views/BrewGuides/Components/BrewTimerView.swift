//
//  BrewTimerView.swift
//  CoffeeMio
//
//  Created by Brandon Jensen on 10/28/25.
//

import SwiftUI

struct BrewTimerView: View {
    let duration: TimeInterval
    let label: String
    @Binding var isCompleted: Bool

    @State private var timeRemaining: TimeInterval
    @State private var isRunning = false
    @State private var timer: Timer?

    init(duration: TimeInterval, label: String, isCompleted: Binding<Bool>) {
        self.duration = duration
        self.label = label
        self._isCompleted = isCompleted
        self._timeRemaining = State(initialValue: duration)
    }

    private var progress: Double {
        guard duration > 0 else { return 0 }
        return 1 - (timeRemaining / duration)
    }

    private var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            // Timer display
            ZStack {
                // Background circle
                Circle()
                    .stroke(Theme.warmOrange.opacity(0.2), lineWidth: 6)
                    .frame(width: 80, height: 80)

                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        isCompleted ? .green : Theme.warmOrange,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.3), value: progress)

                // Time text
                VStack(spacing: 2) {
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.green)
                    } else {
                        Text(timeString)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.primaryBrown)
                    }
                }
            }

            // Label
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)

            // Controls
            HStack(spacing: 12) {
                if !isCompleted {
                    // Start/Pause button
                    Button(action: toggleTimer) {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(isRunning ? Theme.textSecondary : Theme.warmOrange)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Reset button
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(Theme.cardBackground)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    // Restart button when completed
                    Button(action: restartTimer) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 12))
                            Text("Restart")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(Theme.warmOrange)
                        .frame(height: 32)
                        .padding(.horizontal, 12)
                        .background(Theme.cardBackground)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(16)
        .background(Theme.cream)
        .cornerRadius(16)
        .onChange(of: isCompleted) { _, newValue in
            if newValue {
                stopTimer()
            }
        }
    }

    private func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                completeTimer()
            }
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        timeRemaining = duration
        isCompleted = false
    }

    private func restartTimer() {
        resetTimer()
        startTimer()
    }

    private func completeTimer() {
        stopTimer()
        isCompleted = true

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    VStack {
        BrewTimerView(duration: 30, label: "Bloom Phase", isCompleted: .constant(false))
        BrewTimerView(duration: 45, label: "Main Pour", isCompleted: .constant(true))
    }
    .padding()
}
