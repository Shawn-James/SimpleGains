// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// NumberTextField.swift

import UIKit

class NumberTextField: UITextField, UITextFieldDelegate {
    // MARK: - Properties

    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeKeyboard))
        ]
        toolbar.sizeToFit()

        return toolbar
    }()

    // MARK: - Lifecycle

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        keyboardType = .numberPad
        
//        layer.borderColor = UIColor.label.cgColor
//        layer.borderWidth = 2
//        layer.cornerRadius = 8
//        layer.masksToBounds = true

        inputAccessoryView = toolBar // FIXME: - Getting a console dump for auto-layout. Is this Apple's error or developer?
    }

    // MARK: - Private Methods

    @objc private func closeKeyboard() {
        if isFirstResponder {
            resignFirstResponder()
        }
    }
}
