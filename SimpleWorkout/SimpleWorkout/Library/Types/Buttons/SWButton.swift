// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SWButton.swift

import UIKit

class SWButton: UIButton {
    // MARK: - Initializers

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = UIColor.SWColor.primary
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        layer.borderColor = UIColor.SWColor.border.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
}
