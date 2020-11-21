// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// TopGainsViewController.swift

import UIKit

final class TopGainsViewController: CustomViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Private Properties

    @IBOutlet private var emptyDatasetView: UIView!

    @IBOutlet private var tableView: CustomTableView!

    @IBOutlet private var startButton: StandardButton!

    private let exerciseModel = ExerciseModel()

    private let autoCompleteModel = ExercisePermanentRecordModel()

    private var topGains: ExercisePermanentRecords = [] {
        didSet {
            tableView.reloadData()
            configurationForEmptyDataSet()
        }
    }

    private var exercises: Exercises? {
        didSet {
            guard (exercises?.count ?? 0) > 0 else {
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self

        startButton.setTitle("Return Here Next Workout Day 😌", for: .disabled)
        startButton.setTitle("Start Today's Workout 😤", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        topGains = autoCompleteModel.fetchTopGains()
        fetchTodaysExercises()
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topGains.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightDetail", for: indexPath)
        cell.backgroundColor = UIColor.CustomColor.overlay
        cell.layer.borderColor = UIColor.CustomColor.base.cgColor
        cell.layer.borderWidth = 2

        cell.textLabel?.text = topGains[indexPath.row].text

        cell.detailTextLabel?.text = "+\(topGains[indexPath.row].totalGains) 📈"
        cell.detailTextLabel?.textColor = UIColor.CustomColor.primary

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.startWorkout {
            guard let destinationVC = segue.destination as? WorkoutViewController >< "No destinationVC" else { return }

            if let exercises = exercises {
                destinationVC.exercises = exercises
            }
        }
    }

    // MARK: - Private Methods

    private func configurationForEmptyDataSet() {
        if topGains.isEmpty {
            tableView.backgroundView = emptyDatasetView
        } else if topGains.count == 1 {
            tableView.backgroundView = nil
        }
    }

    private func fetchTodaysExercises() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: Date())
        exercises = exerciseModel.fetchExercises(for: weekday)
    }
}
