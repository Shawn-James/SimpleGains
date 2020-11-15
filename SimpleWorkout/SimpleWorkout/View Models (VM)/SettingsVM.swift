// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SettingsVM.swift

protocol SectionType: CaseIterable {
    var headerTitle: String { get }
}

protocol RowType: CaseIterable {
    var cellTitle: String { get }
}

enum SettingsSection: Int, SectionType {
    case section1, colors

    var headerTitle: String {
        switch self {
        case .section1:
            return "Section 1"
        case .colors:
            return "Theme"
        }
    }
}

enum ColorRows: Int, RowType {
    case blue, red, salmon, green

    var cellTitle: String {
        switch self {
        case .blue:
            return "Sky"
        case .red:
            return "Red"
        case .salmon:
            return "Salmon"
        case .green:
            return "Green"
        }
    }

    var hex: Int {
        switch self {
        case .blue:
            return 0x61aeef
        case .red:
            return 0xff0000
        case .salmon:
            return 0xff7e79
        case .green:
            return 0x9898fb
        }
    }
}
