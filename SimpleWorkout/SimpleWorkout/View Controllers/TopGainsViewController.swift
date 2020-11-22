// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// TopGainsViewController.swift

import UIKit

/// Home ViewController used to show topGains and launch the current day's workout
final class TopGainsViewController: CustomViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Private Properties

    /// A view that displays a label to the user when the tableView's dataSource is empty
    @IBOutlet private var emptyDatasetView: UIView!

    /// The tableView that displays the topGains
    @IBOutlet private var tableView: CustomTableView!

    /// Used to display a message or as a button to launch today's workout
    @IBOutlet private var startButton: StandardButton!

    /// Controller used for interacting with the `Exercise` model
    private let exerciseController = ExerciseController()

    /// Controller used for interacting with the `ExercisePermanentRecord` model
    private let permanentRecordController = ExercisePermanentRecordController()

    /// DataSource for the TableView
    private var topGains: ExercisePermanentRecords = [] {
        didSet {
            tableView.reloadData()
            configurationForEmptyDataSet()
        }
    }

    /// Used to count the exercises to
    private var exercises: Exercises? {
        didSet {
            configurationForStartButton()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self

        startButton.setTitle("Return Next Workout Day 😌", for: .disabled)
        startButton.setTitle("Start Today's Workout 😤", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        topGains = permanentRecordController.fetchTopGains()
        fetchTodaysExercises()
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topGains.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopGainsCell = tableView.dequeueReusableCell(for: indexPath)
        cell.exercise = topGains[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.startWorkout {
            guard let destinationVC = segue.destination as? WorkoutViewController >< "No destinationVC" else { return }

            if let exercises = exercises {
                destinationVC.exercises = exercises
            }

            destinationVC.permanentRecordController = permanentRecordController
        }
    }

    // MARK: - Private Methods

    /// Configures the tableView's background with an emptyDatasetView if it's dataSource is empty
    private func configurationForEmptyDataSet() {
        if topGains.isEmpty {
            tableView.backgroundView = emptyDatasetView
        } else if topGains.count == 1 {
            tableView.backgroundView = nil
        }
    }

    /// Populates `exercises` with the exercises scheduled for today's date
    private func fetchTodaysExercises() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: Date())
        exercises = exerciseController.fetchExercises(for: weekday)
    }

    /// Configures the startButton based on whether there are workouts scheduled today and they have not already been completed
    private func configurationForStartButton() {
        guard
            let exercises = exercises, !exercises.isEmpty
        else {
            startButton.isEnabled = false
            startButton.backgroundColor = UIColor.CustomColor.overlay
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = dateFormatter.string(from: Date())

        if todaysDate == UserDefaults.standard.value(forKey: UserDefaultsKey.lastWorkoutDate) as? String {
            startButton.isEnabled = false
            startButton.backgroundColor = UIColor.CustomColor.overlay
        } else {
            startButton.isEnabled = true
            startButton.backgroundColor = UIColor.CustomColor.primary
        }
    }
}
