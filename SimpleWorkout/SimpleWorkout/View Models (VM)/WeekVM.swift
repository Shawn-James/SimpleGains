// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WeekVM.swift

import UIKit

class WeekVM {
    // MARK: - Properties

    var rowCount = Weekday.Day.allCases.count
    let cellReuseId = CellReuseId.scheduleTableViewCell

    // MARK: - Public Methods

    func configureCell(_ cell: UITableViewCell, for weekdayObject: Weekday) {
        guard
            let weekday = weekdayObject.name,
            var exercises = weekdayObject.exercises?.allObjects as? [Exercise]
        else {
            cell.textLabel?.text = weekdayObject.name
            cell.detailTextLabel?.text = "Rest Day"
            return
        }

        exercises.sort { $0.sort < $1.sort }

        var exerciseDetails = String()

        exercises.forEach {
            if let exerciseName = $0.name {
                exerciseDetails += "\(exerciseName)\n"
            }
        }

        cell.textLabel?.text = weekday
        cell.detailTextLabel?.text = !exerciseDetails.isEmpty ? exerciseDetails : "Rest Day"
    }
}
