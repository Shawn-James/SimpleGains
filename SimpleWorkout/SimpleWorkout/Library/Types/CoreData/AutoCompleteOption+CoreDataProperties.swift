// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteOption+CoreDataProperties.swift
//

import CoreData
import Foundation

extension AutoCompleteOption {
    @NSManaged public var text: String
    @NSManaged public var occurrences: Int64

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AutoCompleteOption> {
        return NSFetchRequest<AutoCompleteOption>(entityName: "AutoCompleteOption")
    }
}

extension AutoCompleteOption: Identifiable {}
