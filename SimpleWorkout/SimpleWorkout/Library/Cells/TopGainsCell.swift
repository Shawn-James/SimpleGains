// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// TopGainsCell.swift

import UIKit

/// TableView cell used to display information about exercises with the largest weight increases
final class TopGainsCell: CustomCell, ReusableView {
    // MARK: - Public Properties

    /// The injected object from cellForRowAt used to configure this cell
    var exercise: ExercisePermanentRecord? {
        didSet {
            updateViews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        detailTextLabel?.textColor = UIColor.CustomColor.primary
    }

    /// Configure the cell using the injected object
    private func updateViews() {
        guard let exercise = exercise else { return }

        textLabel?.text = exercise.text
        detailTextLabel?.text = "﹢\(exercise.totalGains)"
    }
}
