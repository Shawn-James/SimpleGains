// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SWNavigationController.swift

import UIKit

class SWNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor.Theme.base
        navigationBar.isTranslucent = false

        navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]

        navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
