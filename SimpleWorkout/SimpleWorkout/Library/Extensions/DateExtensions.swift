// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// DateExtensions.swift

import Foundation

extension Date {
    /// A description of the amount of time that has passed.
    /// - Parameter style: The style to use in formatting
    /// - Returns: A formatted string describing the amount of time that has passed
    func timeAgo(_ style: RelativeDateTimeFormatter.UnitsStyle = .full) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = style
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
