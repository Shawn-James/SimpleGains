// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SettingsViewController.swift

import UIKit

/// View Controller that allows the user to customize the app experience by being able to interact with settings options
final class SettingsViewController: CustomTableViewController {
    // MARK: - Private Properties
    
    /// A flag for only running selectCurrentAppearanceRow when necessary
    var didSelectInitialRow = false

    // MARK: - Lifecycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        selectCurrentAppearanceRow()
    }

    // MARK: - TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SettingsSection(rawValue: section)?.headerTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }

        switch section {
        case .general:
            return GeneralSettingsRow.allCases.count

        case .appearance:
            return AppearanceSettingsRow.allCases.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .general:
            let cell: GeneralSettingsCell = tableView.dequeueReusableCell(for: indexPath)
            cell.row = GeneralSettingsRow(rawValue: indexPath.row)
            return cell

        case .appearance:
            let cell: AppearanceSettingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.row = AppearanceSettingsRow(rawValue: indexPath.row)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let section = SettingsSection(rawValue: indexPath.section),
            let cell = tableView.cellForRow(at: indexPath)
        else { return }

        switch section {
        case .general:
            break // Do nothing

        case .appearance:
            setTheme(with: AppearanceSettingsRow(rawValue: indexPath.row))
            cell.accessoryType = .checkmark
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard
            let section = SettingsSection(rawValue: indexPath.section),
            let cell = tableView.cellForRow(at: indexPath)
        else { return }

        switch section {
        case .general:
            break // Do nothing

        case .appearance:
            cell.accessoryType = .none
        }
    }

    // MARK: - Private Methods
    
    /// Selects the row that represents the current appearance in the tableView
    private func selectCurrentAppearanceRow() {
        guard !didSelectInitialRow else { return }

        for i in 0..<AppearanceSettingsRow.allCases.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: SettingsSection.appearance.rawValue)) as? AppearanceSettingCell {
                if cell.backgroundColor == UIColor.CustomColor.primary {
                    tableView.selectRow(at: tableView.indexPath(for: cell), animated: true, scrollPosition: .none)
                    cell.accessoryType = .checkmark
                }
            }
        }
        
        didSelectInitialRow = true
    }

    /// Changes the `primary` color and the global tint to match the configuration from the user selected row
    /// - Parameter appearanceRow: The used for configuration
    private func setTheme(with appearanceRow: AppearanceSettingsRow?) {
        guard let hexCode = appearanceRow?.hex else { return }

        UserDefaults.standard.setValue(hexCode, forKey: UserDefaultsKey.primaryColor)

        let primaryColor = UIColor(hex: hexCode)

        UINavigationBar.appearance().tintColor = primaryColor // navBar
        UITextField.appearance().tintColor = primaryColor // textField
        StandardButton.appearance().backgroundColor = primaryColor // standardButton
        CircleButton.appearance().backgroundColor = primaryColor // circleButton
        tabBarController?.tabBar.tintColor = primaryColor // tabBar

        UIApplication.shared.delegate?.window??.tintColor = primaryColor // global (requires reload)
    }
}
