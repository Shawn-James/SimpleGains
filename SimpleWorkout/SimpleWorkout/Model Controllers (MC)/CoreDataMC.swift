// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CoreDataMC.swift

import CoreData

class CoreDataMC {
    // MARK: - Properties

    /// Singleton
    static let shared = CoreDataMC()

    /// Persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "PersistentModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return persistentContainer
    }()

    /// Main Context
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Public Methods

    /// Creates new managed objects and saves them to the main context
    /// - Parameter objects: The managed objects to create
    func create(_ : NSManagedObject...) {
        save()
    }

    /// Saves the main context
    func save() {
        do {
            try mainContext.save()

        } catch {
            print("CoreDataMC save error: \(error)")
        }
    }

    /// Deletes an object from the main context
    /// - Parameter object: The object to delete
    func delete(_ object: NSManagedObject) {
        do {
            mainContext.delete(object)
            try mainContext.save()

        } catch {
            print("CoreDataMC delete error: \(error)")
        }
    }
}
