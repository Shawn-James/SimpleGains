// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteOption+CoreDataClass.swift
//

import CoreData
import Foundation

@objc(AutoCompleteOption)
public class AutoCompleteOption: NSManagedObject {
    @discardableResult convenience init(text userInput: String) {
        self.init(context: CoreDataMC.shared.mainContext)

        text = userInput
        occurrences = 1
    }
}
