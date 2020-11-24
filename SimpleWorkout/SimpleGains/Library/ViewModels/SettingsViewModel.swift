// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SettingsViewModel.swift

protocol SectionType: CaseIterable {
    var headerTitle: String { get }
}

protocol RowType: CaseIterable {
    var cellTitle: String { get }
}

// MARK: - Sections & Rows for Settings

enum SettingsSection: Int, SectionType {
    case general, appearance

    var headerTitle: String {
        switch self {
        case .general: return "General"
        case .appearance: return "Appearance"
        }
    }
}

enum GeneralSettingsRow: Int, RowType {
    case autoIncreaseWeight

    var cellTitle: String {
        switch self {
        case .autoIncreaseWeight: return "Pause Auto Weight Increasing"
        }
    }

    var containsSwitch: Bool {
        switch self {
        case .autoIncreaseWeight: return true
        }
    }

    var userDefaultsKey: String {
        switch self {
        case .autoIncreaseWeight: return UserDefaultsKey.pauseAutoWeightIncrease
        }
    }
}

enum AppearanceSettingsRow: Int, RowType {
    case blue, red, salmon, purple, green

    var cellTitle: String {
        switch self {
        case .blue: return "Sky"
        case .red: return "Red"
        case .salmon: return "Salmon"
        case .purple: return "Purple"
        case .green: return "Green"
        }
    }

    var hex: Int {
        switch self {
        case .blue: return 0x61aeef
        case .red: return 0xff2727
        case .salmon: return 0xff7e79
        case .purple: return 0x9898fb
        case .green: return 0x66cd00
        }
    }
}
