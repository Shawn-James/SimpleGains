// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WorkoutCell.swift

import UIKit

/// Custom delegate used to send information to the back to the viewController
protocol CurrentWorkoutTableViewCellDelegate {
    func incrementCompletedExercises(_ shouldIncrement: Bool)
    func shouldIncreaseWeight(_ bool: Bool, for exercise: Exercise)
}

/// A tableView cell that displays a working exercise's properties so the user can perform the exercise and record the results
final class WorkoutCell: CustomCell, ReusableView {
    // MARK: - Public Properties

    /// The exercise injected from cellForRowAt used to configure this cell
    var exercise: Exercise? {
        didSet {
            updateViews()
        }
    }

    /// Custom delegate used to send information to the back to the viewController
    var delegate: CurrentWorkoutTableViewCellDelegate?

    // MARK: - Private Properties

    /// Holds the exercise name
    @IBOutlet private var nameLabel: UILabel!

    /// Holds the exercise weight
    @IBOutlet private var weightLabel: UILabel!

    /// A stack view used to hold a dynamic number of `rep` buttons
    @IBOutlet private var repsStackView: UIStackView!

    /// A flag used to indicate whether the viewController should be told to increase the weight for this exercise when the `finish` button is pressed
    private var increaseWeightFlag = true {
        didSet {
            if let exercise = exercise {
                delegate?.shouldIncreaseWeight(increaseWeightFlag, for: exercise)
            }
        }
    }

    /// A flag used to indicate whether the viewController should be notified that this exercise has all `rep` buttons with values
    private var completeFlag = false {
        didSet {
            delegate?.incrementCompletedExercises(completeFlag)
        }
    }

    /// A counter used to decide wether the `increaseWeightFlag` should be raised. Count all the `reps` buttons that are set to the target rep count
    private var successfulSets = 0 {
        didSet {
            if successfulSets == totalSets {
                increaseWeightFlag = true
            } else if increaseWeightFlag == true {
                increaseWeightFlag = false
            }
        }
    }

    /// A counter used to decide wether the `completeFlag` should be raised. Counts all the `reps` buttons that have values
    private var completedSets = 0 {
        didSet {
            if completedSets == totalSets {
                completeFlag = true
            } else if completeFlag == true {
                completeFlag = false
            }
        }
    }

    /// Holds the total number of sets of the injected exercise
    private var totalSets: Int?

    // MARK: - Lifecycle

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Private Methods

    /// Updates the counters for determining whether the sets are completed and successful. Successful, as in the target reps were reached.
    /// - Parameter sender: The circle button that was pressed
    @objc private func updateCompletedExercises(sender: CircleButton) {
        guard
            let workingReps = Int(sender.title(for: .normal) ?? "Incomplete"),
            let targetReps = sender.repsCount
        else {
            completedSets -= 1
            return
        }

        if workingReps == targetReps {
            completedSets += 1
            successfulSets += 1
        } else if workingReps == targetReps - 1 {
            successfulSets -= 1
        }
    }

    /// Configures the cell using the injected exercise object
    private func updateViews() {
        guard let exercise = exercise else { return }

        totalSets = Int(exercise.sets)

        nameLabel.text = exercise.name
        weightLabel.text = String(exercise.weight)

        if repsStackView.arrangedSubviews.isEmpty {
            // RepsButton(s)
            while repsStackView.arrangedSubviews.count < exercise.sets {
                let repsButton = CircleButton(repsCount: exercise.reps)
                repsButton.addTarget(self, action: #selector(updateCompletedExercises(sender:)), for: .touchUpInside)

                repsStackView.addArrangedSubview(repsButton)
            }

            // Spacer(s)
            while repsStackView.arrangedSubviews.count < 5 {
                let spacer = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                spacer.image = UIImage(systemName: "xmark")
                spacer.tintColor = UIColor.CustomColor.base

                repsStackView.addArrangedSubview(spacer)
            }
        }
    }
}
