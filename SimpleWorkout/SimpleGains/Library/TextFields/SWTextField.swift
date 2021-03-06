// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SWNumberTextField.swift

import UIKit

class SWNumberTextField: UITextField, UITextFieldDelegate {
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

        inputAccessoryView = toolBar // FIXME: - Getting a console dump for auto-layout. Is this Apple's error or developer?
    }

    // MARK: - Private Methods

    @objc private func closeKeyboard() {
        if isFirstResponder {
            resignFirstResponder()
        }
    }
}
