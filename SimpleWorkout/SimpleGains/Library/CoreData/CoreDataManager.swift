// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CoreDataManager.swift

import CoreData

/// The Developers CoreData wrapper used for managing the CoreDataStack
final class CoreDataManager {
    // MARK: - Public Properties

    /// Singleton accessor
    static let shared = CoreDataManager()

    /// Persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let xcdatamodeld = "PersistentModel"
        let persistentContainer = NSPersistentContainer(name: xcdatamodeld)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
            }
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
        return persistentContainer
    }()

    /// Gets the managed object context for the view (main thread)
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// A private managed object context for background operations (background thread)
    private(set) lazy var privateContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()

    // MARK: - Lifecycle

    /// This class should only be accessed through it's singleton
    private init() {}

    // MARK: - Public Methods

    /// Performs a save on the viewContext (main thread)
    func saveViewChanges() {
        performOnMain { [unowned self] in
            guard self.viewContext.hasChanges else { return }

            do {
                try self.viewContext.save()

            } catch {
                let error = error as NSError
                fatalError("CoreDataManager save error \(error), \(error.userInfo)")
            }
        }
    }

    /// Performs a save on the privateContext (background thread)
    func savePrivateChanges() {
        performOnBackground { [unowned self] in
            guard self.privateContext.hasChanges else { return }

            do {
                try self.privateContext.save()

            } catch {
                let error = error as NSError
                fatalError("CoreDataManager save error \(error), \(error.userInfo)")
            }
        }
    }

    /// Deletes an object from the viewContext (main thread)
    /// - Parameter object: The managed object to be deleted
    func deleteFromView(_ object: NSManagedObject) {
        performOnMain { [unowned self] in
            do {
                viewContext.delete(object)
                try self.viewContext.save()

            } catch {
                let error = error as NSError
                fatalError("CoreDataManager save error \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Private Methods

    /// Convenience for performing an action on the viewContext
    /// - Parameter exec: The code to run
    private func performOnMain(_ exec: @escaping () -> Void) {
        viewContext.perform(exec)
    }

    /// Convenience for performing an action on the privateContext
    /// - Parameter exec: The code to run
    private func performOnBackground(_ exec: @escaping () -> Void) {
        privateContext.perform(exec)
    }
}
