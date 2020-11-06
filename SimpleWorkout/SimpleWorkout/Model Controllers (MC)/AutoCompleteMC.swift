// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteMC.swift

import CoreData
import UIKit

class AutoCompleteMC {
    // MARK: - Typealias

    typealias AutoCompleteOptions = [AutoCompleteOption]
    typealias ACOFetchRequest = NSFetchRequest<AutoCompleteOption>

    // MARK: - Properties

    /// The auto-complete suggestions that are used to populate the auto-complete table view
    var autoCompleteSuggestions = [NSAttributedString]()

    // MARK: -  Public Methods

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

        let request: ACOFetchRequest = AutoCompleteOption.fetchRequest()
        let context = CoreDataMC.shared.mainContext

        fetchPrefixMatches(quantity: quantity, userInput: userInput, request: request, context: context)

        let belowQuantity = autoCompleteSuggestions.count < quantity
        if belowQuantity {
            let remaining = quantity - autoCompleteSuggestions.count
            fetchedPatternMatches(remaining: remaining, userInput: userInput, request: request, context: context)
        }
    }

    // MARK: - Private Methods

    /// Removes all autoCompleteSuggestions
    private func cancel() {
        if !autoCompleteSuggestions.isEmpty {
            autoCompleteSuggestions.removeAll(keepingCapacity: true)
        }
    }

    /// Fetches Prefix Matches For Auto-Completion
    /// - Parameters:
    ///   - fetchLimit: The maximum number of auto-complete suggestions to fetch
    ///   - userInput: The string from a UITextfield's text
    ///   - fetchRequest: The shared fetch request
    ///   - context: The shared managedObjectContext
    private func fetchPrefixMatches(quantity fetchLimit: Int, userInput: String, request fetchRequest: ACOFetchRequest, context: NSManagedObjectContext) {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "occurrences", ascending: false)]
        fetchRequest.fetchLimit = fetchLimit

        let usedMoreThanOnce = NSPredicate(format: "occurrences > 1")
        let prefixMatches = NSPredicate(format: "text BEGINSWITH %@", userInput)

        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [prefixMatches, usedMoreThanOnce])

        do {
            let prefixMatches = try context.fetch(fetchRequest)

            autoCompleteSuggestions = prefixMatches.map {
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
    private func fetchedPatternMatches(remaining fetchLimit: Int, userInput: String, request fetchRequest: ACOFetchRequest, context: NSManagedObjectContext) {
        fetchRequest.fetchLimit = fetchLimit

        let usedMoreThanOnce = NSPredicate(format: "occurrences > 0") // FIXME: - change to 1
        let patternMatches = NSPredicate(format: "text CONTAINS %@", userInput)
        let notAddedYet = NSPredicate(format: "NOT (text BEGINSWITH %@)", userInput)

        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [patternMatches, notAddedYet, usedMoreThanOnce])

        do {
            let patternMatches = try context.fetch(fetchRequest)

            autoCompleteSuggestions += patternMatches.map {
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
        attributedString.addAttribute(.foregroundColor, value: UIColor.primary!, range: patternMatch)

        return attributedString
    }
}
