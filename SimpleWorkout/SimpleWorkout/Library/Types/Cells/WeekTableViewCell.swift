// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WeekTableViewCell.swift

import UIKit

public final class WeekTableViewCell: UITableViewCell, ReusableView {
    @IBOutlet private var weekdayLabel: UILabel!
    @IBOutlet private var exercisesLabel: UILabel!

    public override func layoutSubviews() {
        super.layoutSubviews()
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    public func configureCell(withWeekday weekday: Weekday) {
        guard let exercises = weekday.exercises?.allObjects as? [Exercise] else { return }

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
    }
}
