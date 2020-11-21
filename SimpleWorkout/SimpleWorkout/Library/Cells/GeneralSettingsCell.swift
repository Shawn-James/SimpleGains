// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// GeneralSettingsCell.swift

import UIKit

class GeneralSettingsCell: UITableViewCell, ReusableView {
    typealias InjectedObject = GeneralSettingsRow? // FIXME: - Only running first as associated type to satisfy protocol

    var section1Row: GeneralSettingsRow? {
        didSet {
            guard let section1Row = section1Row else { return }

            textLabel?.text = section1Row.cellTitle
            switchControl.isHidden = !section1Row.containsSwitch
        }
    }

    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .red
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchControlHandler), for: .valueChanged)
        return switchControl
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

        backgroundColor = UIColor.CustomColor.overlay
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configureCell(with object: GeneralSettingsRow?) {
        guard let row = object else { return }

        textLabel?.text = row.cellTitle
    }

    @objc private func switchControlHandler(sender: UISwitch) {
        guard let section1Row = section1Row else { return }

//        if sender.isOn {
//            UserDefaults.standard.set(true, forKey: section1Row.userDefaultsKey)
//        } else {
//            UserDefaults.standard.set(false, forKey: section1Row.userDefaultsKey)
//        }
    }
}
