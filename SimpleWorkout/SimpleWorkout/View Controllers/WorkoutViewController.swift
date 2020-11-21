// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WorkoutViewController.swift

import UIKit

class WorkoutViewController: UITableViewController {
    // MARK: - Properties

    @IBOutlet private var finishButton: UIBarButtonItem!

    let controller = ExerciseModel()
    let gains = ExercisePermanentRecordModel()

    var exercises: Exercises = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var exercisesToIncreaseWeight: Exercises = []

    var completedExercises = 0 {
        didSet {
            if completedExercises == exercises.count {
                finishButton.isEnabled = true
            } else if completedExercises == exercises.count - 1, finishButton.isEnabled {
                finishButton.isEnabled = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.CustomColor.base

        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.CustomColor.base
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        finishButton.isEnabled = false

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func finishButtonPressed(_ sender: UIBarButtonItem) {
        incrementWeightForExercises {
            navigationController?.popViewController(animated: true)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = dateFormatter.string(from: Date())

            UserDefaults.standard.setValue(todaysDate, forKey: UserDefaultsKey.lastWorkoutDate)
        }
    }

    private func incrementWeightForExercises(completion: () -> Void) {
        guard !exercisesToIncreaseWeight.isEmpty else { return completion() }

        exercisesToIncreaseWeight.forEach {
            if $0.weight != 0 {
                $0.weight += 5

                gains.updateTotalGains(for: $0)
            }
        }

        CoreDataManager.shared.saveViewChanges()

        completion()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WorkoutCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(with: exercises[indexPath.row])
        cell.delegate = self

        return cell
    }
}

extension WorkoutViewController: CurrentWorkoutTableViewCellDelegate {
    func incrementCompletedExercises(_ shouldIncrement: Bool) {
        if shouldIncrement {
            completedExercises += 1
        } else {
            completedExercises -= 1
        }
    }

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
}
