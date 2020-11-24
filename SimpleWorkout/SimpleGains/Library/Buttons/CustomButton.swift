// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CustomButton.swift

import UIKit

/// Shared button configurations, used for consistent styling
class CustomButton: UIButton {
    // MARK: - Lifecycle

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        sharedInit()
    }

    /// Programmatic init
    override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
    }

    // MARK: - Private Methods

    /// A call to share common initialization tasks from multiple initializer declarations
    private func sharedInit() {
        backgroundColor = UIColor.CustomColor.primary

        setTitleColor(UIColor.CustomColor.invertedLabel, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        layer.borderColor = UIColor.CustomColor.border.cgColor
        layer.borderWidth = 1
    }
}
