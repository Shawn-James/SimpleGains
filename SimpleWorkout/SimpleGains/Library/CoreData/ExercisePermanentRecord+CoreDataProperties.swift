// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExercisePermanentRecord+CoreDataProperties.swift

import CoreData
import Foundation

extension ExercisePermanentRecord {
    @NSManaged public var text: String
    @NSManaged public var occurrences: Int64
    @NSManaged public var totalGains: Int64

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExercisePermanentRecord> {
        return NSFetchRequest<ExercisePermanentRecord>(entityName: "ExercisePermanentRecord")
    }
}

extension ExercisePermanentRecord: Identifiable {}
