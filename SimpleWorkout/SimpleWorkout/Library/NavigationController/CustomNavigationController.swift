// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CustomNavigationController.swift

import UIKit

/// Shared NavigationController configurations, used for consistent styling
class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor.CustomColor.base
        navigationBar.isTranslucent = false

        navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]

        navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
