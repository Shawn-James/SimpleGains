// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WeekVC.swift

import UIKit

class WeekVC: UITableViewController {
    // MARK: - Properties

    // MARK: - Models

    let weekVM = WeekVM()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.navigationBar.makeTransparent()
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekVM.rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weekVM.cellReuseId, for: indexPath)

        weekVM.configureCell(cell, indexPath)

        return cell
    }
}
