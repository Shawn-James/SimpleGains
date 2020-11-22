// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// Themes.swift

import UIKit

extension UIColor {
    enum CustomColor {
        /// The color commonly used for accents, tint, and actions. It defaults to a blue but can be customized by the app user.
        static var primary: UIColor {
            UIColor(hex: UserDefaults.standard.value(forKey: UserDefaultsKey.primaryColor) as? Int ?? 0x61aeef)
        }

        /// A lighter color used to make text less pronounced.
        static var lightText = UIColor(hex: 0x919191)

        /// An alternative text color used on darker backgrounds when the default dark mode label color is too dark.
        static var invertedLabel = UIColor.white

        /// A color used to accentuate some borders
        static var border = UIColor(hex: 0x404040)

        /// An alternate background color used to distinguish views from other views that use the base color.
        static var overlay = UIColor(hex: 0x202020)

        /// The "bottom-most" color that should be thought of as "the background of all backgrounds"
        static var base = UIColor(hex: 0x272727)
    }

    /// Programmer's initializer for instantiating a UIColor using a hex code
    /// - Parameter hex: Hexadecimal number used to represent a color
    convenience init(hex: Int) {
        let components = (R: CGFloat((hex >> 16) & 0xff) / 255,
                          G: CGFloat((hex >> 08) & 0xff) / 255,
                          B: CGFloat((hex >> 00) & 0xff) / 255)
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
