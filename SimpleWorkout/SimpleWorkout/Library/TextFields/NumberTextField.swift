// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// NumberTextField.swift

import UIKit

final class NumberTextField: UITextField, UITextFieldDelegate {
    /// The toolbar to be added above the numberPad keyboard that introduces a `done` button
    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        toolbar.barStyle = .default

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeKeyboard))
        ]
        toolbar.sizeToFit()

        return toolbar
    }()

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        keyboardType = .numberPad

        inputAccessoryView = toolBar // FIXME: - Getting a console dump for auto-layout. Is this Apple's error or developer?
    }

    /// Closes the keyboard when the done button is pressed
    @objc private func closeKeyboard() {
        if isFirstResponder {
            resignFirstResponder()
        }
    }
}
