// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleViewModel.swift

import UIKit

class ScheduleViewModel {
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

    var rowCount = WeekDay.allCases.count
    let cellReuseId = CellReuseId.scheduleTableViewCell

    func getCellTitle(for indexPath: IndexPath) -> String {
        WeekDay(rawValue: indexPath.row)!.description
    }
}
