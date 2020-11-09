// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Exercise+Convenience.swift

extension Exercise {
    /// Programmer's initializer for creating initial weekday managed object
    convenience init(name: String, sort: Int16) {
        self.init(context: CoreDataMC.shared.mainContext)
        
        self.name = name
        self.sort = sort
    }
}
