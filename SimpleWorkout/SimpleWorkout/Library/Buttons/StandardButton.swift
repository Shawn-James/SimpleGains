// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// StandardButton.swift

import UIKit

/// The standard button used throughout the app. If the button is not a circle, it will use this class
final class StandardButton: CustomButton {
    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layer.cornerRadius = 5
    }
}
