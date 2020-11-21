// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteTextField.swift

import UIKit

final class AutoCompleteTextField: UITextField {
    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = UIColor.CustomColor.overlay

        // Create a padding view for padding on left
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.height))
        leftViewMode = .always

        borderStyle = .roundedRect

        font = UIFont(name: "System", size: 17)
        autocapitalizationType = .words
    }
}
