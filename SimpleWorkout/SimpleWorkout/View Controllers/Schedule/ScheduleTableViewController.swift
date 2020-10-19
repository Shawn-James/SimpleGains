// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleTableViewController.swift

import UIKit

class ScheduleTableViewController: UITableViewController {
    let viewModel = ScheduleViewModel()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.rowCount }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseId, for: indexPath)
        cell.textLabel!.text = viewModel.getCellTitle(for: indexPath)
        return cell
    }
}
