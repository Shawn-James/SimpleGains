// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExerciseMC.swift

import CoreData

class ExerciseMC {
    // MARK: - Typealias

    typealias WeekendFetchRequest = NSFetchRequest<Weekday>
    typealias WeekendFetchedResultsController = NSFetchedResultsController<Weekday>

    typealias Weekdays = [Weekday]

    // MARK: - Properties

    // MARK: - Public Methods

    func fetchWeekdays() -> Weekdays {
        let fetchRequest: WeekendFetchRequest = Weekday.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        let mainContext = CoreDataMC.shared.mainContext

        do {
            return try mainContext.fetch(fetchRequest)

        } catch {
            print("Error fetching -> fetchWeekdays() in ExerciseMC: \(error)")
            return []
        }
    }
}
