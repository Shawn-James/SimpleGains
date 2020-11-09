// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WeekVC.swift

import UIKit

class WeekVC: UITableViewController {
    // MARK: - Models

    let weekVM = WeekVM()
    let exerciseMC = ExerciseMC()

    // MARK: - Properties

    var weekdays: [Weekday] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.navigationBar.makeTransparent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        weekdays = exerciseMC.fetchWeekdays()
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekVM.rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weekVM.cellReuseId, for: indexPath)
        let weekday = weekdays[indexPath.row]

        weekVM.configureCell(cell, for: weekday)

        return cell
    }
}
