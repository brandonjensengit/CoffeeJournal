//
//  SettingsView.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var appearanceManager = AppearanceManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacingL) {
                    // Appearance Section
                    VStack(alignment: .leading, spacing: Theme.spacingM) {
                        HStack(spacing: 8) {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Theme.warmOrange)

                            Text("Appearance")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Theme.textPrimary)
                        }

                        VStack(spacing: 12) {
                            ForEach(AppearanceMode.allCases, id: \.self) { mode in
                                AppearanceModeCard(
                                    mode: mode,
                                    isSelected: appearanceManager.selectedMode == mode,
                                    currentColorScheme: colorScheme
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        appearanceManager.selectedMode = mode
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Divider()
                        .padding(.horizontal)

                    // App Info
                    VStack(spacing: Theme.spacingS) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.warmOrange, Theme.goldenBrown],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("Coffee Journal")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Theme.textPrimary)

                        Text("Track your coffee brewing journey")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.textSecondary)

                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary.opacity(0.7))
                            .padding(.top, 4)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.vertical, Theme.spacingL)
            }
            .background(Theme.background)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.primaryBrown)
                }
            }
        }
    }
}

// MARK: - Appearance Mode Card

struct AppearanceModeCard: View {
    let mode: AppearanceMode
    let isSelected: Bool
    let currentColorScheme: ColorScheme

    var body: some View {
        HStack(spacing: Theme.spacingM) {
            // Icon
            ZStack {
                Circle()
                    .fill(isSelected ? Theme.primaryBrown : Theme.cream)
                    .frame(width: 50, height: 50)

                Image(systemName: mode.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Theme.background : Theme.primaryBrown)
            }

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(mode.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)

                Text(modeDescription)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()

            // Checkmark
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Theme.warmOrange)
            }
        }
        .padding(Theme.spacingM)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                .stroke(isSelected ? Theme.warmOrange : Color.clear, lineWidth: 2)
        )
        .shadow(
            color: isSelected
                ? Theme.warmOrange.opacity(0.2)
                : (currentColorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.05)),
            radius: isSelected ? 8 : 4,
            y: 2
        )
    }

    private var modeDescription: String {
        switch mode {
        case .light:
            return "Always use light theme"
        case .dark:
            return "Always use dark theme"
        case .system:
            return "Follow system setting"
        }
    }
}

#Preview {
    SettingsView()
}
