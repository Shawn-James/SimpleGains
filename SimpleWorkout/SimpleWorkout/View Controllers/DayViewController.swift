// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// DayViewController.swift

import UIKit

class DayViewController: UIViewController, SuggestionsViewActionsDelegate {
    // MARK: - Typealias

    typealias SuggestionsData = UITableViewDiffableDataSource<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>
    typealias SuggestionsSnapshot = NSDiffableDataSourceSnapshot<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>

    // MARK: - Models

    private var autoComplete = ExerciseSuggestionEngine()

    // MARK: - Outlets & Properties

    @IBOutlet var textField: UITextField!
    @IBOutlet var dropDown: AutoCompleteSuggestionsView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = dropDown
        dropDown.actionsDelegate = self
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
        textField.text?.removeAll(keepingCapacity: false)
    }
}
