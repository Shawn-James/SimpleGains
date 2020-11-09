// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AppNavigation.swift

import UIKit

extension WeekVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueId.scheduleTableViewCellPressed:
            guard
                let destinationVC = segue.destination as? DayVC >< "No destinationVC",
                let selectedIndexPath = tableView.indexPathForSelectedRow >< "No selectedIndexPath"
            else {
                fatalError("Programmer Error: Missing Dependencies")
            }

            destinationVC.title = weekdays[selectedIndexPath.row].name
            destinationVC.weekday = weekdays[selectedIndexPath.row]

        default: fatalError("WeekVC is missing a segue.identifier for \(segue.identifier!)")
        }
    }
}
