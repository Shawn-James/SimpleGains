// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExercisePermanentRecordController.swift

import CoreData
import UIKit

typealias ExercisePermanentRecords = [ExercisePermanentRecord]

/// Model controller used to interact with the `ExercisePermanentRecord` model
final class ExercisePermanentRecordController {
    typealias PermanentRecordFetchRequest = NSFetchRequest<ExercisePermanentRecord>

    // MARK: - Public Properties

    /// The auto-complete results that are used to populate the auto-complete table view
    var autoCompleteResults: [NSAttributedString] = []

    // MARK: - Public Methods

    /// Fetches exercise auto-complete suggestions using a textField's text
    /// - Parameters:
    ///   - quantity: The maximum number of suggestions to return
    ///   - userInput: The text from a UITextfield
    func fetchAutoCompleteSuggestions(quantity: Int, for userInput: String?) {
        guard let userInput = userInput?.capitalized // Must be capitalized to get matches
        else {
            cancel()
            return
        }

        let request: PermanentRecordFetchRequest = ExercisePermanentRecord.fetchRequest()
        let context = CoreDataManager.shared.viewContext

        fetchPrefixMatches(quantity: quantity, userInput: userInput, request: request, context: context)

        let belowQuantity = autoCompleteResults.count < quantity
        if belowQuantity {
            let remaining = quantity - autoCompleteResults.count
            fetchedPatternMatches(remaining: remaining, userInput: userInput, request: request, context: context)
        }
    }

    /// Fetches the permanent records with the greatest weight increases
    /// - Returns: Max 25 ExercisePermanentRecords that have total gains above `0`, sorted descending
    func fetchTopGains() -> ExercisePermanentRecords {
        let fetchRequest: PermanentRecordFetchRequest = ExercisePermanentRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "totalGains > 0")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "totalGains", ascending: false)]
        fetchRequest.fetchLimit = 25

        let context = CoreDataManager.shared.viewContext

        do {
            return try context.fetch(fetchRequest)

        } catch {
            print("Error fetching in fetchTopGains(): \(error)")
            return []
        }
    }

    /// Updates the permanent record matching the exercise name by increasing it's `totalGains` by 5
    /// - Parameter exercise: The exercise use for permanent record lookup
    func updateTotalGains(for exercise: Exercise, by increaseAmount: Int16) {
        guard let exerciseName = exercise.name else { return }

        let fetchRequest: PermanentRecordFetchRequest = ExercisePermanentRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "text MATCHES %@", exerciseName)
        fetchRequest.fetchLimit = 1

        let privateContext = CoreDataManager.shared.privateContext

        do {
            let exercise = try privateContext.fetch(fetchRequest).first
            exercise?.totalGains += Int64(increaseAmount)

            try privateContext.save()

        } catch {
            print(error)
        }
    }

    /// Adds a new autoComplete option for the userInput or increments the occurrence count if one already exists.
    /// - Parameter userInput: The text from the textfield
    func incrementAutoCompleteOccurrenceCount(for userInput: String) {
        let fetchRequest: NSFetchRequest<ExercisePermanentRecord> = ExercisePermanentRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "text MATCHES %@", userInput)

        var fetchedExercisePermanentRecord: ExercisePermanentRecord?

        do {
            fetchedExercisePermanentRecord = try CoreDataManager.shared.viewContext.fetch(fetchRequest).first // FIXME: - fetchLimit of 1 instead

        } catch {
            print("Error fetching in updateTextOccurrence(): \(error)")
        }

        if let ExercisePermanentRecord = fetchedExercisePermanentRecord {
            ExercisePermanentRecord.occurrences += 1
        } else {
            ExercisePermanentRecord(text: userInput)
        }

        CoreDataManager.shared.saveViewChanges()
    }

    // MARK: - Private Methods

    /// Removes all autoCompleteSuggestions
    private func cancel() {
        if !autoCompleteResults.isEmpty {
            autoCompleteResults.removeAll(keepingCapacity: true)
        }
    }

    /// Fetches Prefix Matches For Auto-Completion
    /// - Parameters:
    ///   - fetchLimit: The maximum number of auto-complete suggestions to fetch
    ///   - userInput: The string from a UITextfield's text
    ///   - fetchRequest: The shared fetch request
    ///   - context: The shared managedObjectContext
    private func fetchPrefixMatches(quantity fetchLimit: Int, userInput: String, request fetchRequest: PermanentRecordFetchRequest, context: NSManagedObjectContext) {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "occurrences", ascending: false)]
        fetchRequest.fetchLimit = fetchLimit

        let usedMoreThanOnce = NSPredicate(format: "occurrences > 1") // We want to prevent from suggesting "one-time typos"
        let prefixMatches = NSPredicate(format: "text BEGINSWITH %@", userInput)

        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [prefixMatches, usedMoreThanOnce])

        do {
            let prefixMatches = try context.fetch(fetchRequest)

            autoCompleteResults = prefixMatches.map {
                let originalText = $0.text.capitalized
                return formatPatternMatches(pattern: userInput, original: originalText)
            }

        } catch {
            print("Error fetching prefix matches: \(error)")
        }
    }

    /// Fetches Pattern Matches For Remaining Spots
    /// - Parameters:
    ///   - fetchLimit: The maximum number of auto-complete suggestions to fetch
    ///   - userInput: The string from a UITextfield's text
    ///   - fetchRequest: The shared fetch request
    ///   - context: The shared managedObjectContext
    private func fetchedPatternMatches(remaining fetchLimit: Int, userInput: String, request fetchRequest: PermanentRecordFetchRequest, context: NSManagedObjectContext) {
        fetchRequest.fetchLimit = fetchLimit

        let usedMoreThanOnce = NSPredicate(format: "occurrences > 1") // We want to prevent from suggesting "one-time typos"
        let patternMatches = NSPredicate(format: "text CONTAINS %@", userInput)
        let notAddedYet = NSPredicate(format: "NOT (text BEGINSWITH %@)", userInput)

        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [patternMatches, notAddedYet, usedMoreThanOnce])

        do {
            let patternMatches = try context.fetch(fetchRequest)

            autoCompleteResults += patternMatches.map {
                let originalText = $0.text.capitalized
                return formatPatternMatches(pattern: userInput, original: originalText)
            }

        } catch {
            print("Error fetching pattern matches: \(error)")
        }
    }

    /// Creates an attributed string with unique formatting to distinguish matching patterns
    /// - Parameters:
    ///   - userInput: The string that was passed in from the UITextfield's text
    ///   - fullText: The original string
    /// - Returns: An attributed string with unique formatting for any matching patterns
    private func formatPatternMatches(pattern: String, original: String) -> NSMutableAttributedString {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: original)
        let patternMatch = (original as NSString).range(of: pattern, options: .caseInsensitive)

        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: patternMatch)
        attributedString.addAttribute(.foregroundColor, value: UIColor.CustomColor.primary, range: patternMatch)

        return attributedString
    }
}
