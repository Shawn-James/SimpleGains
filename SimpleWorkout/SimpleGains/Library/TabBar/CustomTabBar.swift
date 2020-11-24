// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CustomTabBar.swift

import UIKit

class CustomTabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 1

        tabBar.backgroundColor = UIColor.CustomColor.overlay
    }
}
