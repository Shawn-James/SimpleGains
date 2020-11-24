// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CustomTableView.swift

import UIKit

/// Shared TableView configurations, used for consistent styling
class CustomTableView: UITableView {
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor.CustomColor.base

        separatorColor = .clear
    }
}
