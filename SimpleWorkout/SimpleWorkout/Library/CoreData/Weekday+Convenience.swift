// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Weekday+Convenience.swift

import Foundation

extension Weekday {
    /// An enum to represent the days of the week
    enum Day: String, CaseIterable {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
    }

    /// Programmer's initializer for creating initial weekday managed object
    /// - Parameter day: The name of the weekday
    @discardableResult convenience init(_ day: Day) {
        self.init(context: CoreDataManager.shared.privateContext)

        name = day.rawValue
        order = Int16(Day.allCases.firstIndex(of: day)!) // Programmer error if missing case
    }
}
