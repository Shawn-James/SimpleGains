// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// TabBarVC.swift

import UIKit

class TabBarVC: UITabBarController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
    }
}

//        navigationController?.navigationBar.makeTransparent()

//        tabBar.backgroundImage = UIImage()
//        tabBar.shadowImage = UIImage()
//        let blurView = UIView()
//        blurView.blur()
//        tabBar.addSubview(blurView)
//        tabBar.backgroundColor = .clear

//        tabBar.backgroundImage = UIImage()
//        tabBar.shadowImage = UIImage()
//        tabBar.backgroundColor = .clear
//
//        let bounds = tabBar.bounds
//        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
//        visualEffectView.frame = bounds
//        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        tabBar.addSubview(visualEffectView)
//        tabBar.sendSubviewToBack(visualEffectView)
