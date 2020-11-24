// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WorkoutViewController.swift

import UIKit

/// View Controller used for managing live workouts
final class WorkoutViewController: CustomTableViewController, CurrentWorkoutTableViewCellDelegate {
    // MARK: - Public Properties

    /// The exercises schedule for todays date; injected from the TopGainsViewController
    var exercises: Exercises = [] {
        didSet {
            tableView.reloadData()
        }
    }

    /// Controller used for interacting with the `ExercisePermanentRecord` model. Injected from TopGainsViewController
    var permanentRecordController: ExercisePermanentRecordController?

    // MARK: - Private Properties

    /// Bar button used to confirm that a workout has been completed
    @IBOutlet private var finishButton: UIBarButtonItem!

    /// Exercises that have been marked to receive weight increase updates
    private var exercisesToIncreaseWeight: Exercises = []

    /// Counter for all of the rows with completed exercises. When all exercises are completed, `finishButton` is enabled
    private var completedExercises = 0 {
        didSet {
            configurationForFinishButton()
        }
    }
    
    /// A constant for how much the weight of exercises should increase by upon successful completion
    let increaseAmount: Int16 = 10

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        finishButton.isEnabled = false

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WorkoutCell = tableView.dequeueReusableCell(for: indexPath)
        cell.exercise = exercises[indexPath.row]
        cell.delegate = self
        return cell
    }

    // MARK: - CurrentWorkoutTableViewCell Delegate

    /// Updates the `completedExercises` counter by 1 in the desired direction
    /// - Parameter shouldIncrement: True if should increment, False if should decrease
    func incrementCompletedExercises(_ shouldIncrement: Bool) {
        if shouldIncrement {
            completedExercises += 1
        } else {
            completedExercises -= 1
        }
    }

    /// Adds or removes items from `exercisesToIncreaseWeight`
    /// - Parameters:
    ///   - bool: True adds, False removes
    ///   - exercise: The exercise to add or remove
    func shouldIncreaseWeight(_ bool: Bool, for exercise: Exercise) {
        switch bool {
        case true:
            exercisesToIncreaseWeight.append(exercise)
        case false:
            if let indexForExerciseToRemove = exercisesToIncreaseWeight.firstIndex(of: exercise) {
                exercisesToIncreaseWeight.remove(at: indexForExerciseToRemove)
            }
        }
    }

    // MARK: - Private Methods

    /// Handles the barButton tap for `finishButton`. User confirms the have finished working out
    /// - Parameter sender: The `finishButton`
    @IBAction private func finishButtonPressed(_ sender: UIBarButtonItem) {
        incrementWeightForExercises {
            navigationController?.popViewController(animated: true)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = dateFormatter.string(from: Date())

            UserDefaults.standard.setValue(todaysDate, forKey: UserDefaultsKey.lastWorkoutDate)
        }
    }

    /// Perform the updates to increase the weight for the exercises in `exercisesToIncreaseWeight`
    /// - Parameter completion: Completion handler; called after the updates have been performed
    private func incrementWeightForExercises(completion: () -> Void) {
        guard
            !UserDefaults.standard.bool(forKey: UserDefaultsKey.pauseAutoWeightIncrease),
            !exercisesToIncreaseWeight.isEmpty
        else {
            return completion()
        }

        exercisesToIncreaseWeight.forEach {
            if $0.weight != 0 {
                $0.weight += increaseAmount

                permanentRecordController?.updateTotalGains(for: $0, by: increaseAmount)
            }
        }

        CoreDataManager.shared.saveViewChanges()

        completion()
    }

    /// Enables or disables the `finishButton` based on whether or not the workout has been complete
    private func configurationForFinishButton() {
        if completedExercises == exercises.count {
            finishButton.isEnabled = true
        } else if completedExercises == exercises.count - 1, finishButton.isEnabled {
            finishButton.isEnabled = false
        }
    }
}
