// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// DayViewController.swift

import UIKit

class DayViewController: UIViewController, SuggestionsViewActionsDelegate, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Typealias

    typealias SuggestionsData = UITableViewDiffableDataSource<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>
    typealias SuggestionsSnapshot = NSDiffableDataSourceSnapshot<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>

    // MARK: - Models

    private var autoComplete = ExerciseSuggestionEngine()

    // MARK: - Outlets & Properties

    @IBOutlet var textField: UITextField!
    @IBOutlet var dropDown: AutoCompleteSuggestionsView!
    @IBOutlet var addedExercisesTableView: UITableView!
    @IBOutlet var emptyDataSetView: UIView!

    var addedExerciseNames: [String] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = dropDown
        addedExercisesTableView.dataSource = self
        addedExercisesTableView.delegate = self
        dropDown.actionsDelegate = self
        
        configurationForEmptyDataSet()
    }

    // MARK: - Public Methods

    func replaceTextFieldText(with text: String) {
        textField.text = text
        view.endEditing(true)
        DispatchQueue.main.async {
            self.dropDown.hideDropDown()
        }
    }

    // MARK: - Private Methods

    @IBAction func addButtonPressed(_ sender: SWButton) {
        guard let exerciseName = textField.text, !exerciseName.isEmpty else { return }

        addedExerciseNames.append(exerciseName)

        addedExercisesTableView.reloadData()

        textField.text?.removeAll(keepingCapacity: false)

        configurationForEmptyDataSet()
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addedExerciseNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = addedExercisesTableView.dequeueReusableCell(withIdentifier: "AddedExercisesTableViewCell", for: indexPath)
            as? AddedExercisesTableViewCell
        else { fatalError("Programmer error: Cell dequeue error") }

        cell.label.text = addedExerciseNames[indexPath.row]

        return cell
    }

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
