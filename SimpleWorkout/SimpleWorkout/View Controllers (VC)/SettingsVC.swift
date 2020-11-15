// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SettingsVC.swift

import UIKit

class SettingsVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SettingsSection(rawValue: section)?.headerTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let settingsSection = SettingsSection(rawValue: section) else { return 0 }

        switch settingsSection {
        case .section1:
            return 0
        case .colors:
            return ColorRows.allCases.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let settingsSection = SettingsSection(rawValue: indexPath.section),
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell")
        else {
            return UITableViewCell()
        }

        switch settingsSection {
        case .section1:
            break
        case .colors:
            if let colorForRow = ColorRows(rawValue: indexPath.row) {
                cell.textLabel?.text = colorForRow.cellTitle
                cell.backgroundColor = UIColor(hex: colorForRow.hex)
                if UIColor(hex: colorForRow.hex) == UIColor.SWColor.primary {
                    cell.accessoryType = .checkmark
                }
                cell.selectionStyle = .none
            }
        }

        cell.tintColor = .white

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let settingsSection = SettingsSection(rawValue: indexPath.section),
            let selectedCell = tableView.cellForRow(at: indexPath)
        else { return }

        switch settingsSection {
        case .section1:
            break
        case .colors:
            if let colorForRow = ColorRows(rawValue: indexPath.row) {
                tableView.deselectRow(at: indexPath, animated: true)

                tableView.visibleCells.forEach { // FIXME: - handle check mark
                    $0.accessoryType = .none // reset?
                }

                setTheme(with: colorForRow.hex)

                selectedCell.accessoryType = .checkmark
            }
        }
    }

    private func setTheme(with primaryColorHex: Int) {
        UserDefaults.standard.setValue(primaryColorHex, forKey: UserDefaultsKey.primaryColor)

        let primaryColor = UIColor(hex: primaryColorHex)

        tabBarController?.tabBar.tintColor = primaryColor // tabBar
        UINavigationBar.appearance().tintColor = primaryColor // navBar
        SWButton.appearance().backgroundColor = primaryColor // button
        SWRoundButton.appearance().backgroundColor = primaryColor // circle button
        UITextField.appearance().tintColor = primaryColor // textField
        UIApplication.shared.delegate?.window??.tintColor = primaryColor // all tints (requires reload)
    }
}
