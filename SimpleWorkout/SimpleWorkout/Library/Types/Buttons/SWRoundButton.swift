// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SWRoundButton.swift

import UIKit

class SWRoundButton: UIButton {
    // MARK: - Lifecycle

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = UIColor.Theme.primary
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        layer.borderColor = UIColor.Theme.border.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = bounds.height / 2

        addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
    }

    @objc private func handleButtonPress() {
        let currentValue = Int(title(for: .normal) ?? "0") ?? 0
        let newValue = "\(currentValue + 1)"

        setTitle(newValue, for: .normal)
    }
}
