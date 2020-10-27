// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SearchViewController.swift

import UIKit

final class SearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    // MARK: - Typealias

    typealias SuggestionsData = UITableViewDiffableDataSource<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>
    typealias SuggestionsSnapshot = NSDiffableDataSourceSnapshot<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>

    // MARK: - Models

    private var autoComplete = ExerciseSuggestionEngine()

    // MARK: - Outlets & Properties

//    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var suggestionList: UITableView!

    private var autoCompleteTableView: SuggestionsData!
    private let cellReuseId = CellReuseId.suggestionDropDown

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        suggestionList.delegate = self
        suggestionList.allowsMultipleSelection = false

//        searchBar.delegate = self
//        searchBar.returnKeyType = .done

        cellForRowAt()
    }

    // MARK: - Search Bar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text?.lowercased(), !searchTerm.isEmpty else {
            autoComplete.cancel(); updateTableView(); return
        }

        autoComplete.updateResults(for: searchTerm); updateTableView()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { // FIXME: - Doesn't work
        autoComplete.cancel(); updateTableView()
    }

    // MARK: - TableView

    func cellForRowAt() {
        autoCompleteTableView = SuggestionsData(tableView: suggestionList, cellProvider: { (tableView, indexPath, exercise) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId, for: indexPath)

            cell.textLabel?.text = exercise.name.capitalized

            return cell
        })
    }

    func updateTableView() {
        var update = SuggestionsSnapshot()

        update.appendSections(ExerciseSuggestionEngine.Section.allCases) // FIXME: - Would this be faster with only one section?

        update.appendItems(autoComplete.suggestions)

        DispatchQueue.main.async {
            self.autoCompleteTableView.apply(update, animatingDifferences: true)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)

        guard let exercise = autoCompleteTableView.itemIdentifier(for: indexPath) else { return } // temp dummy func
        print(exercise)
    }
}
