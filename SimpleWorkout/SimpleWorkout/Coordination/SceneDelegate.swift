// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SceneDelegate.swift

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        window?.tintColor = UIColor.CustomColor.primary // set global tint
        window?.overrideUserInterfaceStyle = .dark // force dark mode to inherit consistent text colors, etc...
    }
}
