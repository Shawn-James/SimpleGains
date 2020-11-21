// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// WorkoutCell.swift

import UIKit

protocol CurrentWorkoutTableViewCellDelegate {
    func incrementCompletedExercises(_ shouldIncrement: Bool)
    func shouldIncreaseWeight(_ bool: Bool, for exercise: Exercise)
}

class WorkoutCell: CustomCell, ReusableView {
    // MARK: - Typealias

    typealias InjectedObject = Exercise

    // MARK: - Properties

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var repsStackView: UIStackView!

    var exercise: Exercise?

    var delegate: CurrentWorkoutTableViewCellDelegate?

    var increaseWeightFlag = true {
        didSet {
            if let exercise = exercise {
                delegate?.shouldIncreaseWeight(increaseWeightFlag, for: exercise)
            }
        }
    }

    var completeFlag = false {
        didSet {
            delegate?.incrementCompletedExercises(completeFlag)
        }
    }

    var successfulSets = 0 {
        didSet {
            if successfulSets == totalSets {
                increaseWeightFlag = true
            } else if increaseWeightFlag == true {
                increaseWeightFlag = false
            }
        }
    }

    var completedSets = 0 {
        didSet {
            if completedSets == totalSets {
                completeFlag = true
            } else if completeFlag == true {
                completeFlag = false
            }
        }
    }

    var totalSets: Int?

    // MARK: - Methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configureCell(with object: Exercise) {
        exercise = object
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
}

// Handle finish button behavior

// all cells are incomplete

// isComplete flag when value hits or leaves target -> True increments completionCount, False decrements.
// When completionCount = allSets.count, enable `finish` button
