// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteTableView.swift

import CoreData
import UIKit

protocol AutoCompleteTableViewMyDelegate {
    func replaceTextFieldText(with text: String)
}

class AutoCompleteTableView: UITableView, UITableViewDelegate, UITextFieldDelegate {
    typealias SuggestionsData = UITableViewDiffableDataSource<Int, NSAttributedString>
    typealias SuggestionsSnapshot = NSDiffableDataSourceSnapshot<Int, NSAttributedString>

    // MARK: - Model

    private var autoCompleteModel = ExercisePermanentRecordModel()
    private var fetchedResultsController: NSFetchedResultsController<ExercisePermanentRecord>?

    // MARK: - Properties

    private var suggestionsDataSource: SuggestionsData!
    var myDelegate: AutoCompleteTableViewMyDelegate?

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }

    // MARK: - Lifecycle

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        isHidden = true
        delegate = self
        isScrollEnabled = false
        separatorStyle = .none
        backgroundColor = .clear

        cellForRowAt()
    }

    // MARK: - Public Methods

    func showDropDown() {
        isHidden = false; alpha = 1
    }

    func hideDropDown() {
        isHidden = true; alpha = 0
    }

    // MARK: - TableView

    func cellForRowAt() {
        suggestionsDataSource = SuggestionsData(tableView: self, cellProvider: { (tableView, indexPath, autoCompleteSuggestion) -> UITableViewCell? in
            let cell: AutoCompleteCell = tableView.dequeueReusableCell(for: indexPath)
            cell.autoCompleteSuggestion = autoCompleteSuggestion
            return cell
        })
    }

    func updateTableView() {
        snapshotView(afterScreenUpdates: true)

        var update = SuggestionsSnapshot()
        update.appendSections([0])
        update.appendItems(autoCompleteModel.autoCompleteResults)

        DispatchQueue.main.async {
            self.suggestionsDataSource.apply(update, animatingDifferences: false)

            self.visibleCells.first?.setSelected(true, animated: false)

            self.autoCompleteModel.autoCompleteResults.isEmpty ? self.hideDropDown() : self.showDropDown()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let autofill = suggestionsDataSource.itemIdentifier(for: indexPath) else { return }

        myDelegate?.replaceTextFieldText(with: autofill.string)
    }

    // MARK: - Textfield

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if let firstCell = visibleCells.first, let indexPath = indexPath(for: firstCell) {
            tableView(self, didSelectRowAt: indexPath)
        }

        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        autoCompleteModel.fetchAutoCompleteSuggestions(quantity: 8, for: textField.text?.lowercased()) // FIXME: - Need to be saved as lowercase as well? remove lowercase

        updateTableView()
    }
}
