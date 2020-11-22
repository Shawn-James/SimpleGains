// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleCell.swift

import UIKit

/// A tableView cell that displays both the weekday and the scheduled exercise details for that weekday
final class ScheduleCell: CustomCell, ReusableView {
    // MARK: - Public Properties

    /// Injected from cellForRowAt, used to configure cell
    var weekday: Weekday? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Private Properties

    /// Holds name of the weekday
    @IBOutlet private var weekdayLabel: UILabel!

    /// A multi-line label that holds the exercises and their details
    @IBOutlet private var exercisesLabel: UILabel!

    /// Stores the live calendar weekday for today
    private lazy var todaysWeekday: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }()

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        exercisesLabel.textColor = UIColor.CustomColor.lightText
    }

    // MARK: - Private Methods

    /// Configures the cell using the injected object
    private func updateViews() {
        guard
            let weekday = weekday,
            let exercises = weekday.exercises?.allObjects as? Exercises
        else { return }

        let exerciseDetails = exercises
            .sorted {
                $0.order < $1.order
            }
            .map {
                "\($0.name ?? "No Name") \($0.sets) x \($0.reps), \($0.weight)\n" // Format Details String
            }
            .joined()
            .dropLast(1) // Removes "\n" (line break) on last exercise

        weekdayLabel.text = weekday.name
        exercisesLabel.text = String(exerciseDetails)

        if weekdayLabel.text == todaysWeekday {
            weekdayLabel.textColor = UIColor.CustomColor.primary
        }
    }
}
