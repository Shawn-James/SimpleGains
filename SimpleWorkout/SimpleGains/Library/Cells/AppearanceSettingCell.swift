// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AppearanceSettingCell.swift

import UIKit

/// Cells that populate the rows of the `Appearance` section. They hold color configurations. When a row is selected, the `primary` color is set to that color
final class AppearanceSettingCell: UITableViewCell, ReusableView {
    // MARK: - Public Properties

    /// The injected row object from cellForRowAt
    var row: AppearanceSettingsRow? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        tintColor = .white

        layer.borderColor = UIColor.CustomColor.base.cgColor
        layer.borderWidth = 2
    }

    // MARK: - Private Methods

    /// Configures the cell using the injected object
    private func updateViews() {
        guard let row = row else { return }

        textLabel?.text = row.cellTitle
        backgroundColor = UIColor(hex: row.hex)
    }
}
