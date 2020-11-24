// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExerciseController.swift

import CoreData

typealias Exercises = [Exercise]
typealias Weekdays = [Weekday]

/// Model controller used to interact with the `Exercise` model
final class ExerciseController {
    typealias WeekdayFetchRequest = NSFetchRequest<Weekday>

    // MARK: - Public Properties

    /// The fetched results controller used to configure the scheduleDetailViewController's tableView for a given weekday
    var fetchedResultsController: NSFetchedResultsController<Exercise>? {
        didSet {
            try? fetchedResultsController?.performFetch()
        }
    }

    // MARK: - Public Methods
    
    /// Fetches the exercises for a given weekday
    /// - Parameter weekday: A string representation of a weekday
    /// - Returns: An array of Exercises matching the given weekday
    public func fetchExercises(for weekday: String) -> Exercises {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weekday.name == %@", weekday) // FIXME: - matches
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        do {
            let scooby = try CoreDataManager.shared.viewContext.fetch(fetchRequest)
            return scooby

        } catch {
            print("Error fetching -> fetchExercises() in ExerciseController: \(error)")
            return []
        }
    }
    
    /// Fetches all weekday and the exercises tied to them
    /// - Returns: An array of all 7 Weekdays
    func fetchWeekdays() -> Weekdays {
        let fetchRequest: WeekdayFetchRequest = Weekday.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        do {
            return try CoreDataManager.shared.viewContext.fetch(fetchRequest)

        } catch {
            print("Error fetching -> fetchWeekdays() in ExerciseController: \(error)")
            return []
        }
    }
    
    /// Configures the fetchedResultsController for a given weekday
    /// - Parameters:
    ///   - weekday: A weekday object
    ///   - completion: Completion handler to run after configure the FRC
    func configureFetchedResultsController(for weekday: Weekday, completion: () -> Void) {
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
    
    /// Creates a new Exercise object and saves it to CoreData
    /// - Parameters:
    ///   - name: The name of the exercise
    ///   - weekday: The weekday object to add the new exercise to
    func createNewExercise(named name: String, for weekday: Weekday) {
        guard let exerciseCount = weekday.exercises?.count else { return }

        let newExercise = Exercise(name: name, numberOfExercises: exerciseCount)
        weekday.addToExercises(newExercise)

        CoreDataManager.shared.saveViewChanges()
    }
}
