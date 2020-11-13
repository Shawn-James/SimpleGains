// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AppDelegate.swift

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let firstLaunch = UserDefaults.standard.value(forKey: UserDefaultsKey.firstLaunch) as? Bool ?? true

        if firstLaunch {
            installInitialDatabase()
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

    private func installInitialDatabase() {
        _ = Weekday(.monday)
        _ = Weekday(.tuesday)
        _ = Weekday(.wednesday)
        _ = Weekday(.thursday)
        _ = Weekday(.friday)
        _ = Weekday(.saturday)
        _ = Weekday(.sunday)

        _ = AutoCompleteOption(name: "Bench Press")
        _ = AutoCompleteOption(name: "Sit-Ups")
        _ = AutoCompleteOption(name: "Push-Ups")
        _ = AutoCompleteOption(name: "Incline Bench Press")
        _ = AutoCompleteOption(name: "Decline Bench Press")
        _ = AutoCompleteOption(name: "Leg Press")
        _ = AutoCompleteOption(name: "Squats")
        _ = AutoCompleteOption(name: "Pull-Ups")
        _ = AutoCompleteOption(name: "Military Press")
        _ = AutoCompleteOption(name: "Hamstring Curls")
        _ = AutoCompleteOption(name: "Calf Extensions")
        _ = AutoCompleteOption(name: "Bent-Over Rows")
        _ = AutoCompleteOption(name: "Bicep Curls")
        _ = AutoCompleteOption(name: "Lat Pulldowns")
        _ = AutoCompleteOption(name: "Lunges")
        _ = AutoCompleteOption(name: "Ab Crunches")
        _ = AutoCompleteOption(name: "Shrugs")
        _ = AutoCompleteOption(name: "Lateral Raises")
        _ = AutoCompleteOption(name: "Deadlifts")
        _ = AutoCompleteOption(name: "Back Squats")
        _ = AutoCompleteOption(name: "Barbell Hip Thrusts")

        CoreData.shared.savePrivateChanges()

        UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.firstLaunch)
    }
}
