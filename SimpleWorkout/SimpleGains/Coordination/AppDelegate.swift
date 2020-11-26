// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AppDelegate.swift

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let firstLaunch = UserDefaults.standard.value(forKey: UserDefaultsKey.firstLaunch) as? Bool ?? true // If no value - is first launch

        if firstLaunch {
            installInitialDatabase()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
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

        _ = ExercisePermanentRecord(name: "Bench Press")
        _ = ExercisePermanentRecord(name: "Sit-Ups")
        _ = ExercisePermanentRecord(name: "Push-Ups")
        _ = ExercisePermanentRecord(name: "Incline Bench Press")
        _ = ExercisePermanentRecord(name: "Decline Bench Press")
        _ = ExercisePermanentRecord(name: "Leg Press")
        _ = ExercisePermanentRecord(name: "Squats")
        _ = ExercisePermanentRecord(name: "Pull-Ups")
        _ = ExercisePermanentRecord(name: "Military Press")
        _ = ExercisePermanentRecord(name: "Hamstring Curls")
        _ = ExercisePermanentRecord(name: "Calf Extensions")
        _ = ExercisePermanentRecord(name: "Bent-Over Rows")
        _ = ExercisePermanentRecord(name: "Bicep Curls")
        _ = ExercisePermanentRecord(name: "Lat Pulldowns")
        _ = ExercisePermanentRecord(name: "Lunges")
        _ = ExercisePermanentRecord(name: "Ab Crunches")
        _ = ExercisePermanentRecord(name: "Shrugs")
        _ = ExercisePermanentRecord(name: "Lateral Raises")
        _ = ExercisePermanentRecord(name: "Deadlifts")
        _ = ExercisePermanentRecord(name: "Back Squats")
        _ = ExercisePermanentRecord(name: "Barbell Hip Thrusts")

        CoreDataManager.shared.savePrivateChanges()

        UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.firstLaunch)
        
        // Default Settings
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.smartWeightIncreasing)
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.syncExercisesByName)
    }
}
