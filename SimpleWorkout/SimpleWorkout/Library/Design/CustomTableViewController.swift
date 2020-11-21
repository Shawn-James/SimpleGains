// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CustomTableViewController.swift

import UIKit
/// Shared button configurations, used for consistent styling

class CustomTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.CustomColor.base

        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.CustomColor.base
    }
}
