// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ViewExtensions.swift

import UIKit

extension UIView {
    /// Shortcut to `addSubview` and `translatesAutoresizingMaskIntoConstraints = false`
    func subviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.addSubview(subview)
        }
    }
}
