// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AppearanceSettingCell.swift

import UIKit

class AppearanceSettingCell: UITableViewCell, ReusableView {
    typealias InjectedObject = AppearanceSettingsRow?

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        tintColor = .white

        layer.borderColor = UIColor.CustomColor.base.cgColor
        layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        accessoryType = selected ? .checkmark : .none
    }

    public func configureCell(with object: AppearanceSettingsRow?) {
        guard let colorForRow = object else { return }

        textLabel?.text = colorForRow.cellTitle
        backgroundColor = UIColor(hex: colorForRow.hex)
    }
}
