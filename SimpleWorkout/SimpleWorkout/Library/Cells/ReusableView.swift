// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ReusableView.swift

import UIKit

protocol ReusableView {
    static var reuseId: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseId: String {
        return String(describing: self)
    }
}
