// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleViewController.swift

import UIKit

class ScheduleViewController: UIViewController {
    // MARK: - Properties

    let viewModel = ScheduleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Tableview

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseId, for: indexPath)

        cell.textLabel!.text = viewModel.getCellTitle(for: indexPath)

        return cell
    }
}
