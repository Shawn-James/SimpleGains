// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Themes.swift

import UIKit

extension UIColor {
    enum SWColor {
        /// Primary Color: Default is blue
        static var primary: UIColor {
            UIColor(hex: UserDefaults.standard.value(forKey: UserDefaultsKey.primaryColor) as? Int ?? 0x61aeef)
        }

        static var base = UIColor(named: "Base")!
        static var overlay = UIColor(named: "Overlay")!
        static var border = UIColor(named: "Border")!

        static var text = UIColor(named: "Text")!
        static var lightText = UIColor(named: "LightText")!
    }

    convenience init(hex: Int) {
        let components = (R: CGFloat((hex >> 16) & 0xff) / 255,
                          G: CGFloat((hex >> 08) & 0xff) / 255,
                          B: CGFloat((hex >> 00) & 0xff) / 255)
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
