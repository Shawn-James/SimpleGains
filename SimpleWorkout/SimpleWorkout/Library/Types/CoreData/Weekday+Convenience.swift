// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Weekday+Convenience.swift

import Foundation

extension Weekday {
    enum Day: Int, CaseIterable, CustomStringConvertible {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday

        var description: String {
            switch self {
            case .monday:
                return "Monday"
            case .tuesday:
                return "Tuesday"
            case .wednesday:
                return "Wednesday"
            case .thursday:
                return "Thursday"
            case .friday:
                return "Friday"
            case .saturday:
                return "Saturday"
            case .sunday:
                return "Sunday"
            }
        }
    }

    /// Programmer's initializer for creating initial weekday managed object
    convenience init(_ weekdayNumber: Int16, _ day: Day) {
        self.init(context: CoreDataMC.shared.mainContext)

        order = weekdayNumber
        name = day.description
    }
}
