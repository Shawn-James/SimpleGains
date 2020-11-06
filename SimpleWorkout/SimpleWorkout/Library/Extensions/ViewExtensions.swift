// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ViewExtensions.swift

import UIKit

extension UIView {
    /// Shortcut to `addSubview` and `translatesAutoresizingMaskIntoConstraints = false`
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.addSubview(subview)
        }
    }

    func blur() {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }

    func unBlur() {
        subviews.forEach {
            if $0 is UIVisualEffectView {
                $0.removeFromSuperview()
            }
        }
    }
}
