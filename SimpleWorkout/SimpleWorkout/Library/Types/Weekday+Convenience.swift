// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Weekday+Convenience.swift

extension Weekday {
    enum Day: String {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
    }

    /// Programmer's initializer for creating weekday managed object
    convenience init(_ day: Day, exercises: [Exercise]?) {
        self.init()

        name = day.rawValue
        
        exercises?.forEach {
            addToExercises($0)
        }
    }
}
