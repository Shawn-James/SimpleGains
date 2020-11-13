// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExerciseMC.swift

import CoreData

class ExerciseMC {
    // MARK: - Typealias

    typealias WeekdayFetchRequest = NSFetchRequest<Weekday>
//    typealias WeekdayFetchedResultsController = NSFetchedResultsController<Weekday>

    typealias Weekdays = [Weekday]

    // MARK: - Properties

    var fetchedResultsController: NSFetchedResultsController<Exercise>? {
        didSet {
                do {
                    try fetchedResultsController?.performFetch()

                } catch {
                    print("Error Fetching -> applyPredicate in ExerciseMC: \(error)")
                }
        }
    }

    // MARK: - Public Methods

    func fetchWeekdays() -> Weekdays {
        let fetchRequest: WeekdayFetchRequest = Weekday.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
//      NSSortDescriptor(key: "exercises.order", ascending: true)] // FIXME: - Doesn't work

        let mainContext = CoreData.shared.viewContext

        do {
            return try mainContext.fetch(fetchRequest)

        } catch {
            print("Error fetching -> fetchWeekdays() in ExerciseMC: \(error)")
            return []
        }
    }

    func initFetchedResultsController(for weekday: Weekday) {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weekday = %@", weekday)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)] // This is required, but intentionally, it should do nothing

        let mainContext = CoreData.shared.viewContext

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: mainContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    }

    func createNewExercise(named name: String, for weekday: Weekday, completion: () -> Void) {
        guard let exerciseCount = weekday.exercises?.count else { return }
        
        let newExercise = Exercise(name: name, numberOfExercises: exerciseCount)
        weekday.addToExercises(newExercise)
        
        CoreData.shared.saveViewChanges()
        
        completion()
    }
}
