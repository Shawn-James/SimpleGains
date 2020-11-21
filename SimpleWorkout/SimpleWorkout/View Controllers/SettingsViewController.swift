// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SettingsViewController.swift

import UIKit

class SettingsViewController: CustomTableViewController {
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
            cell.configureCell(with: GeneralSettingsRow(rawValue: indexPath.row))
            return cell

        case .appearance:
            let cell: AppearanceSettingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureCell(with: AppearanceSettingsRow(rawValue: indexPath.row))
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }

        switch section {
        case .general:
            break // Do nothing

        case .appearance:
            setTheme(with: AppearanceSettingsRow(rawValue: indexPath.row))
        }
    }

    // MARK: - Private Methods

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
