// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExerciseModel.swift

import CoreData

typealias Exercises = [Exercise]
typealias Weekdays = [Weekday]

class ExerciseModel {
    typealias WeekdayFetchRequest = NSFetchRequest<Weekday>

    // MARK: - Properties

    var fetchedResultsController: NSFetchedResultsController<Exercise>? {
        didSet {
            try? fetchedResultsController?.performFetch()
//            
//            
//            do {
//                try fetchedResultsController?.performFetch()
//            } catch {
//                print("Error Fetching -> applyPredicate in ExerciseModel: \(error)")
//            }
        }
    }

    // MARK: - Public Methods

    public func fetchExercises(for weekday: String) -> Exercises {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weekday.name == %@", weekday) // FIXME: - matches
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        do {
            let scooby = try CoreDataManager.shared.viewContext.fetch(fetchRequest)
            return scooby

        } catch {
            print("Error fetching -> fetchExercises() in ExerciseModel: \(error)")
            return []
        }
    }

    func fetchWeekdays() -> Weekdays {
        let fetchRequest: WeekdayFetchRequest = Weekday.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
//      NSSortDescriptor(key: "exercises.order", ascending: true)] // FIXME: - Doesn't work

        do {
            return try CoreDataManager.shared.viewContext.fetch(fetchRequest)

        } catch {
            print("Error fetching -> fetchWeekdays() in ExerciseModel: \(error)")
            return []
        }
    }

    func initFetchedResultsController(for weekday: Weekday, completion: () -> Void) {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weekday = %@", weekday)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        let mainContext = CoreDataManager.shared.viewContext

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: mainContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)

        completion()
    }

    func createNewExercise(named name: String, for weekday: Weekday) {
        guard let exerciseCount = weekday.exercises?.count else { return }

        let newExercise = Exercise(name: name, numberOfExercises: exerciseCount)
        weekday.addToExercises(newExercise)

        CoreDataManager.shared.saveViewChanges()
    }
}
