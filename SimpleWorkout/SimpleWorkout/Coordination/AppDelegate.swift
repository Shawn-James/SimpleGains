// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AppDelegate.swift

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let firstLaunch = UserDefaults.standard.value(forKey: UserDefaultsKey.firstLaunch) as? Bool ?? true
        if firstLaunch {
            installStandardAutoCompleteOptions()

            UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.firstLaunch)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Supporting Methods

    private func installStandardAutoCompleteOptions() {
        guard let url = Bundle.main.url(forResource: "StandardAutoCompleteOptions", withExtension: "plist") else { return }

        do {
            let plist = try Data(contentsOf: url)
            let standardAutoCompleteOptions = try PropertyListDecoder().decode([String].self, from: plist)

            standardAutoCompleteOptions.forEach {
                let object = AutoCompleteOption(text: $0)
                let minCountToAllowFetching: Int64 = 2
                object.occurrences = minCountToAllowFetching
                CoreDataMC.shared.create(object: object)
            }

        } catch {
            print("Error installing standard auto-complete options: \(error)")
        }
    }
}
