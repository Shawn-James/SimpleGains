// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteCell.swift

import UIKit

/// A tableView cell used to show exercise names used for autoCompletion
final class AutoCompleteCell: UITableViewCell, ReusableView {
    // MARK: - Public Properties
    
    /// The object injected from cellForRowAt, used to configure this cell
    var autoCompleteSuggestion: NSAttributedString? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .secondarySystemBackground // TODO: This could be improved by using a `custom color` in the future
    }

    // MARK: - Private Methods

    /// Configures the cell text using the injected object
    private func updateViews() {
        textLabel?.attributedText = autoCompleteSuggestion
    }
}
