// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteSuggestionsView.swift

import UIKit

protocol SuggestionsViewActionsDelegate {
    func replaceTextFieldText(with text: String)
}

class AutoCompleteSuggestionsView: UITableView, UITableViewDelegate, UITextFieldDelegate {
    // MARK: - Typealias

    typealias SuggestionsData = UITableViewDiffableDataSource<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>
    typealias SuggestionsSnapshot = NSDiffableDataSourceSnapshot<ExerciseSuggestionEngine.Section, ExerciseSuggestionEngine.Exercise>

    // MARK: - Model

    private var autoComplete = ExerciseSuggestionEngine()

    // MARK: - Properties

    private var autoCompleteTableView: SuggestionsData!
    private let cellReuseId = CellReuseId.suggestionDropDown
    var actionsDelegate: SuggestionsViewActionsDelegate?

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

    // MARK: - Private Methods

    private func boldPatternMatchString(searchTerm: String, fullText: String) -> NSMutableAttributedString {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: fullText)
        let patternMatch = (fullText as NSString).range(of: searchTerm, options: .caseInsensitive)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: patternMatch)
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "AccentColor")!, range: patternMatch)
        return attributedString
    }

    // MARK: - TableView

    func cellForRowAt() {
        autoCompleteTableView = SuggestionsData(tableView: self, cellProvider: { (tableView, indexPath, exercise) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId, for: indexPath)

//            cell.textLabel?.text = exercise.name.capitalized // no formatting
            cell.textLabel?.attributedText = self.boldPatternMatchString(searchTerm: self.autoComplete.pattern ?? "",
                                                                         fullText: exercise.name.capitalized)

            cell.backgroundColor = .secondarySystemBackground
            
//            highlight color:
//            let highlightColor = UIView(); highlightColor.backgroundColor = UIColor(named: "AccentColor")
//            cell.selectedBackgroundView = highlightColor

            return cell
        })
    }

    func updateTableView() {
        var update = SuggestionsSnapshot()

        update.appendSections(ExerciseSuggestionEngine.Section.allCases) // FIXME: - Would this be faster with only one section?

        update.appendItems(autoComplete.suggestions)

        DispatchQueue.main.async {
            self.autoCompleteTableView.apply(update, animatingDifferences: false)
            self.visibleCells.first?.setSelected(true, animated: false)
            if self.autoComplete.suggestions.isEmpty { self.hideDropDown() } else { self.showDropDown() }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let suggestion = autoCompleteTableView.itemIdentifier(for: indexPath)?.name.capitalized else { return }

        actionsDelegate?.replaceTextFieldText(with: suggestion)
    }

    // MARK: - Textfield

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let first = visibleCells.first, let indexPath = indexPath(for: first) {
            tableView(self, didSelectRowAt: indexPath)
        }

        superview?.endEditing(true); return true // FIXME: - why does this have to be on the superview?
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        autoComplete.cancel(); updateTableView(); return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let userInput = textField.text?.lowercased(), !userInput.isEmpty else {
            autoComplete.cancel(); updateTableView(); return
        }

        autoComplete.updateResults(for: userInput); updateTableView()
    }
}
