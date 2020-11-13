// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AutoCompleteTextField.swift

import UIKit

class AutoCompleteTextField: UITextField {
    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        font = UIFont(name: "System", size: 17)
        autocapitalizationType = .words
        borderStyle = .roundedRect

        // Create a padding view for padding on left
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.height))
        leftViewMode = .always
        
        backgroundColor = UIColor.Theme.overlay
    }
}
