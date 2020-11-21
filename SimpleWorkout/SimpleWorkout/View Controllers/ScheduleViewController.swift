// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleViewController.swift

import UIKit

final class ScheduleViewController: UITableViewController {
    // MARK: - Private Properties

    private let exerciseModel = ExerciseModel()

    private var weekdays: Weekdays = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        weekdays = exerciseModel.fetchWeekdays()
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekdays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleCell = tableView.dequeueReusableCell(for: indexPath)
        cell.weekday = weekdays[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.scheduleTableViewCellPressed {
            guard
                let destinationVC = segue.destination as? ScheduleDetailViewController >< "No destinationVC",
                let selectedIndexPath = tableView.indexPathForSelectedRow >< "No selectedIndexPath"
            else {
                fatalError("Programmer Error: Missing Dependencies")
            }

            let selectedWeekday = weekdays[selectedIndexPath.row]

            destinationVC.weekday = selectedWeekday

            exerciseModel.initFetchedResultsController(for: selectedWeekday) {
                destinationVC.exerciseModel = exerciseModel
            }
        }
    }
}
