// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ExerciseSuggestionEngine.swift

import Foundation

class ExerciseSuggestionEngine {
    // MARK: - Typealias

    typealias Exercises = [Exercise]

    // MARK: - Decodables

    struct Exercise: Codable, Hashable {
        let name: String
        let section: Section
    }

    enum Section: String, Codable, CaseIterable {
        case abdominals
        case abductors
        case adductors
        case biceps
        case calves
        case chest
        case forearms
        case glutes
        case hamstrings
        case lats
        case neck
        case quadriceps
        case shoulders
        case traps
        case triceps
        case lowerBack = "lower back"
        case middleBack = "middle back"
        case empty = ""
    }

    // MARK: - Properties

    var suggestions: Exercises = []

    // MARK: -  Methods

    /// Get autocomplete suggestions for the given searchTerm
    /// - Parameter searchTerm: User Input
    func updateResults(for searchTerm: String) {
        let exercises: Exercises = decodeExercisesDataset()

        suggestions = autocompleteSuggestions(for: searchTerm, in: exercises, limit: 8)
    }

    /// Removes all suggestions
    func cancel() {
        suggestions.removeAll(keepingCapacity: true)
    }

    // MARK: - Private Methods

    /// Decodes the dataset from exercises.json
    /// - Returns: An array of all existing Exercise objects
    private func decodeExercisesDataset() -> Exercises {
        do {
            let url = Bundle.main.url(forResource: "exercises", withExtension: "json")!
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Exercises.self, from: data)
        } catch {
            fatalError("Failed to read exercises.json dataset")
        }
    }

    /// A string search that prioritizes prefix-first results, then matching-patterns second
    /// - Parameters:
    ///   - searchTerm: What to search for
    ///   - dataset: Where to search
    /// - Returns: An array of a specified amount of suggested Exercise objects
    private func autocompleteSuggestions(for searchTerm: String, in dataset: Exercises, limit: Int) -> Exercises { // FIXME: - Rename this and
        // Autocomplete
        var suggestions = dataset.filter { $0.name.hasPrefix(searchTerm) } // prefix match is the priority
        suggestions.sort(by: { $0.name.count < $1.name.count }) // smallest strings first

        // Fill remaining spots with similar suggestions
        if suggestions.count < limit {
            var similarResults = dataset.filter { $0.name.contains(searchTerm) && !suggestions.contains($0) } // pattern matching
            similarResults.sort(by: { $0.name.count < $1.name.count }) // smallest strings first
            suggestions += similarResults
        }

        suggestions = Array(suggestions.prefix(limit)) // only return the specified amount

        return suggestions
    }
}
