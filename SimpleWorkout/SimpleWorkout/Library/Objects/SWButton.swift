// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SWButton.swift

import UIKit

class SWButton: UIButton {
    // MARK: - Initializers

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = UIColor(named: "AccentColor")
        setTitleColor(.label, for: .normal)
        layer.borderColor = UIColor.systemBackground.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
    }
}
