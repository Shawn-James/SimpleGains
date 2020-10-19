// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AppCoordinator.swift

import UIKit

extension ScheduleTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueId.scheduleTableViewCellPressed:
            guard
                let destinationVC = segue.destination as? DayTableViewController >< "No destinationVC",
                let selectedIndexPath = tableView.indexPathForSelectedRow >< "No selectedIndexPath"
            else {
                fatalError("Missing Dependencies")
            }
            destinationVC.title = viewModel.getCellTitle(for: selectedIndexPath)
        default: fatalError("ScheduleTableViewController is missing a segue.identifier for \(segue.identifier!)")
        }
    }
}
