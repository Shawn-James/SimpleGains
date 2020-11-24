// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Exercise+Convenience.swift

extension Exercise {
    /// Programmer's initializer for creating an Exercise managed object
    /// - Parameters:
    ///   - name: The name of the exercise
    ///   - lastIndex: The last index of the tableView, used to save it's position at the end
    @discardableResult convenience init(name: String, numberOfExercises lastIndex: Int) {
        self.init(context: CoreDataManager.shared.viewContext)

        self.name = name
        reps = 1
        sets = 1
        order = Int16(lastIndex)
    }
}
