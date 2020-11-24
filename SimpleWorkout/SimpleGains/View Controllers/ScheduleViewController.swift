// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleViewController.swift

import UIKit

/// An TableViewController that provides overview of the scheduled exercises for the week
final class ScheduleViewController: CustomTableViewController {
    // MARK: - Private Properties

    /// Controller used for interacting with the `Exercise` model
    private let exerciseModel = ExerciseController()

    /// DataSource for the TableView; holds the weekdays and their exercises
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

            exerciseModel.configureFetchedResultsController(for: selectedWeekday) {
                destinationVC.exerciseController = exerciseModel
            }
        }
    }
}
