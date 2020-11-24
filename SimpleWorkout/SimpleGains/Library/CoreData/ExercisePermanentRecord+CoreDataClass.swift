// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExercisePermanentRecord+CoreDataClass.swift

import CoreData
import Foundation

@objc(ExercisePermanentRecord)
class ExercisePermanentRecord: NSManagedObject {
    /// Convenience for creating a new ExercisePermanentRecord with `1` occurrence
    /// - Parameter userInput: Text from a textfield that represents the exercise name
    @discardableResult convenience init(text userInput: String) {
        self.init(context: CoreDataManager.shared.viewContext)

        text = userInput
        occurrences = 1
        totalGains = 0
    }

    /// Convenience for creating an ExercisePermanentRecords upon install with `2` occurrences so it will qualify for autoComplete fetching
    /// - Parameter stockName: A string from the programmer that represents the exercise name
    @discardableResult convenience init(name stockName: String) {
        self.init(context: CoreDataManager.shared.privateContext)

        text = stockName
        occurrences = 2
        totalGains = 0
    }
}
