// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WeekVM.swift

import UIKit

class WeekVM {
    // MARK: - Nested Types

    enum WeekDay: Int, CaseIterable, CustomStringConvertible {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday

        var description: String {
            switch self {
            case .monday: return "Monday"
            case .tuesday: return "Tuesday"
            case .wednesday: return "Wednesday"
            case .thursday: return "Thursday"
            case .friday: return "Friday"
            case .saturday: return "Saturday"
            case .sunday: return "Sunday"
            }
        }
    }

    // MARK: - Properties

    var rowCount = WeekDay.allCases.count
    let cellReuseId = CellReuseId.scheduleTableViewCell

    // MARK: - Public Methods

    func configureCell(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        cell.textLabel?.text = WeekDay(rawValue: indexPath.row)?.description
    }
    
    func destinationVCTitle(for selectedIndexPath: IndexPath) -> String {
        WeekDay(rawValue: selectedIndexPath.row)?.description ?? ""
    }
}
