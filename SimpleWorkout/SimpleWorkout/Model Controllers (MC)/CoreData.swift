// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CoreData.swift

import CoreData

public final class CoreData {
    // MARK: - Singleton

    public static let shared = CoreData()
    private init() {}

    // MARK: - Container

    /// Persistent container
    public lazy var persistentContainer: NSPersistentContainer = {
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

    // MARK: - Contexts

    /// Gets the managed object context for the view (main thread)
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// Gets a private managed object context for save operations (background thread)
    private(set) lazy var privateContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()

    // MARK: - Methods

    public func savePrivateChanges() {
        performOnBackground { [unowned self] in
            guard self.privateContext.hasChanges else { return }

            do {
                try self.privateContext.save()

            } catch {
                let error = error as NSError
                fatalError("CoreData save error \(error), \(error.userInfo)")
            }
        }
    }

    public func saveViewChanges() {
        performOnMain { [unowned self] in
            guard self.viewContext.hasChanges else { return }

            do {
                try self.viewContext.save()

            } catch {
                let error = error as NSError
                fatalError("CoreData save error \(error), \(error.userInfo)")
            }
        }
    }

    public func deleteFromView(_ object: NSManagedObject) {
        performOnMain { [unowned self] in
            do {
                viewContext.delete(object)
                try self.viewContext.save()

            } catch {
                let error = error as NSError
                fatalError("CoreData save error \(error), \(error.userInfo)")
            }
        }
    }

//    public func save(context: NSManagedObjectContext) {
//        performOnBackground {
//            guard context.hasChanges else { return }
//
//            do {
//                try context.save()
//
//            } catch {
//                let error = error as NSError
//                fatalError("CoreData save error \(error), \(error.userInfo)")
//            }
//        }
//    }

    public func performOnMain(_ exec: @escaping () -> Void) {
        viewContext.perform(exec)
    }

    public func performOnBackground(_ exec: @escaping () -> Void) {
        privateContext.perform(exec)
    }
}

extension NSManagedObjectContext {
//    public func saveChanges() {
//        perform { [weak self] in
//            guard
//                let self = self,
//                self.hasChanges
//            else { return }
//
//            do {
//                try self.save()
//
//            } catch {
//                let error = error as NSError
//                fatalError("CoreData save error \(error), \(error.userInfo)")
//            }
//        }
//    }
}
