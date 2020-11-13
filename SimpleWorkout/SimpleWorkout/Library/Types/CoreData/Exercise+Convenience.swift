// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Exercise+Convenience.swift

extension Exercise {
    /// Programmer's initializer for creating an Exercise managed object
    @discardableResult convenience init(name: String, numberOfExercises lastIndex: Int) {
        self.init(context: CoreData.shared.viewContext)

        self.name = name
        order = Int16(lastIndex)
    }
}
