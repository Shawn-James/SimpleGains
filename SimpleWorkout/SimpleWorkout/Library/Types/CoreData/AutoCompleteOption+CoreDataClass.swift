// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteOption+CoreDataClass.swift
//

import CoreData
import Foundation

@objc(AutoCompleteOption)
public class AutoCompleteOption: NSManagedObject {
    @discardableResult convenience init(text userInput: String) {
        self.init(context: CoreData.shared.viewContext)

        text = userInput
        occurrences = 1
    }

    @discardableResult convenience init(name stockName: String) {
        self.init(context: CoreData.shared.privateContext)

        text = stockName
        occurrences = 2 // This is the minimum number required to be fetched
    }
}
