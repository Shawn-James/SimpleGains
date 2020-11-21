// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CustomCell.swift

import UIKit
/// Shared button configurations, used for consistent styling

class CustomCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.CustomColor.overlay

        layer.borderColor = UIColor.CustomColor.base.cgColor
        layer.borderWidth = 2
    }
}
