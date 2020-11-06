// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// DayVC.swift

import CoreData
import UIKit

final class DayVC: UIViewController {
    // MARK: - Typealias

    typealias AutoCompleteData = UITableViewDiffableDataSource<Int, Exercise>
    typealias AutoCompleteSnapshot = NSDiffableDataSourceSnapshot<Int, Exercise>

    typealias ACOFetchRequest = NSFetchRequest<AutoCompleteOption>

    // MARK: - Models

    private var autoCompleteMC = AutoCompleteMC()
    private var dayVM = DayVM()

    // MARK: - Properties

    @IBOutlet private var autoCompleteTextField: UITextField!
    @IBOutlet private var autoCompleteDropdown: AutoCompleteTableView!

    @IBOutlet private var addedExercisesTableView: UITableView!
    @IBOutlet private var emptyDataSetView: UIView!

    private var addedExerciseNames: [String] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        autoCompleteTextField.delegate = autoCompleteDropdown
        addedExercisesTableView.dataSource = self
        addedExercisesTableView.delegate = self
        autoCompleteDropdown.actionsDelegate = self

        configurationForEmptyDataSet()
    }

    // MARK: - Public Methods

    // MARK: - Private Methods

    /// Adds exercises to the tableView and updates their occurrence count for auto-complete sorting purposes
    /// - Parameter sender: The add button itself
    @IBAction private func addButtonPressed(_ sender: SWButton) {
        guard let exerciseName = autoCompleteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !exerciseName.isEmpty
        else { return }

        autoCompleteTextField.text?.removeAll(keepingCapacity: false)

        addedExerciseNames.append(exerciseName)

        if !addedExerciseNames.isEmpty {
            configurationForEmptyDataSet()

            incrementAutoCompleteOccurrenceCount(for: exerciseName)

            addedExercisesTableView.reloadData()
        }
    }

    /// Adds a new autoComplete option for the userInput or increments the occurrence count if one already exists.
    /// - Parameter userInput: The text from the textfield
    private func incrementAutoCompleteOccurrenceCount(for userInput: String) {
        let fetchRequest: NSFetchRequest<AutoCompleteOption> = AutoCompleteOption.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "text MATCHES %@", userInput)

        var fetchedAutoCompleteOption: AutoCompleteOption?

        do {
            fetchedAutoCompleteOption = try CoreDataMC.shared.mainContext.fetch(fetchRequest).first

        } catch {
            print("Error fetching in updateTextOccurrence(): \(error)")
        }

        if let autoCompleteOption = fetchedAutoCompleteOption {
            autoCompleteOption.occurrences += 1
        } else {
            CoreDataMC.shared.create(object: AutoCompleteOption(text: userInput))
        }
    }

    /// Configures the tableView's appearance based on whether or not it is empty.
    private func configurationForEmptyDataSet() {
        switch addedExerciseNames.isEmpty {
        case true:
            navigationItem.largeTitleDisplayMode = .always
            addedExercisesTableView.backgroundView = emptyDataSetView
            addedExercisesTableView.separatorStyle = .none
            addedExercisesTableView.isScrollEnabled = false

        case false:
            navigationItem.largeTitleDisplayMode = .never
            addedExercisesTableView.backgroundView = .none
            addedExercisesTableView.separatorStyle = .singleLine
            addedExercisesTableView.isScrollEnabled = true
        }
    }
}

// MARK: - TableView

extension DayVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addedExerciseNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addedExercisesTableView.dequeueReusableCell(withIdentifier: dayVM.cellReuseId, for: indexPath) as? AddedExercisesTableViewCell
        else {
            fatalError("Programmer error: Cell dequeue error")
        }

        cell.label.text = addedExerciseNames[indexPath.row]

        return cell
    }
}

// MARK: - TableView Actions Delegate

extension DayVC: AutoCompleteTableViewActionsDelegate {
    /// Auto-fills the textField with the given text
    /// - Parameter autoFill: The text used to replace the UITextfield's text
    internal func replaceTextFieldText(with autoFill: String) {
        autoCompleteTextField.endEditing(true)
        autoCompleteTextField.text = autoFill

        autoCompleteDropdown.hideDropDown()
    }
}
