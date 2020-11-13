// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WeekVC.swift

import UIKit

class WeekVC: UITableViewController {
    // MARK: - Models

    let controller = ExerciseMC()

    // MARK: - Properties

    var weekdays: [Weekday] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        weekdays = controller.fetchWeekdays()
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekdays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeekTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(withWeekday: weekdays[indexPath.row])

        return cell
    }
}
