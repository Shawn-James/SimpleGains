// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// GeneralSettingsCell.swift

import UIKit

/// Cells that populate the rows of the `General` section. The can have switches.
final class GeneralSettingsCell: UITableViewCell, ReusableView {
    // MARK: - Public Properties

    /// The injected row object from cellForRowAt
    var row: GeneralSettingsRow? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Private Properties

    /// A switch control used to toggle a general setting on or off
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .green
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchControlHandler), for: .valueChanged)
        return switchControl
    }()

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

        backgroundColor = UIColor.CustomColor.overlay
    }

    // MARK: - Private Methods

    /// Handles the value changes for the switch control. Toggles the setting in user defaults and updates the app experience according to that setting
    @objc private func switchControlHandler(sender: UISwitch) {
        guard let row = row else { return }
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: row.userDefaultsKey)
        } else {
            UserDefaults.standard.set(false, forKey: row.userDefaultsKey)
        }
    }

    /// Configures the cell using the injected object
    private func updateViews() {
        guard let row = row else { return }

        textLabel?.text = row.cellTitle

        switchControl.isHidden = !row.containsSwitch
        switchControl.setOn(UserDefaults.standard.bool(forKey: row.userDefaultsKey), animated: true)
    }
}
