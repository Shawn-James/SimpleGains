// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// NavBarExtensions.swift

import UIKit

extension UINavigationBar {
    func makeTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        backgroundColor = .clear
    }
}
