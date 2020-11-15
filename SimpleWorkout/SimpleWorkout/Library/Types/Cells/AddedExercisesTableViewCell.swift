// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AddedExercisesTableViewCell.swift

import UIKit

final class AddedExercisesTableViewCell: SWTableViewCell, ReusableView {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var setsButton: SWRoundButton!
    @IBOutlet var repsLabel: UILabel!
    @IBOutlet var repsButton: SWRoundButton!

    // MARK: - Dependencies

    var exercise: Exercise?

    override func layoutSubviews() {
        super.layoutSubviews()

        weightLabel.textColor = UIColor.SWColor.lightText
        setsLabel.textColor = UIColor.SWColor.lightText
        repsLabel.textColor = UIColor.SWColor.lightText
    }

    // MARK: - Methods

    public func configureCell(withExercise exercise: Exercise?) {
        guard let exercise = exercise else { return }

        self.exercise = exercise

        nameLabel.text = exercise.name

        weightTextField.text = exercise.weight != 0 ?
            "\(exercise.weight)" : "" // Defaults to placeholder

        exercise.sets != 0 ?
            setsButton.setTitle("\(exercise.sets)", for: .normal) : setsButton.setTitle("?", for: .normal)

        exercise.reps != 0 ?
            repsButton.setTitle("\(exercise.reps)", for: .normal) : repsButton.setTitle("?", for: .normal)
    }

    public func resetButtonValues() {
        guard let exercise = exercise else { return }

        exercise.sets = 0; setsButton.setTitle("?", for: .normal)
        exercise.reps = 0; repsButton.setTitle("?", for: .normal)
    }

    // MARK: - Private Methods

    @IBAction func TextFieldEditingDidEnd(_ sender: NumberTextField) {
        guard
            let exercise = exercise,
            let newValue = Int16(sender.text!)
        else { return }

        switch sender {
        case weightTextField:
            exercise.weight = newValue

        default:
            fatalError("Programmer error, missing case in textFieldEditingDidEnd for AddedExercisesTableViewCell")
        }

        CoreData.shared.saveViewChanges()
    }

    @IBAction private func buttonValueChanged(_ sender: SWRoundButton) {
        guard
            let exercise = exercise,
            let newValue = Int16(sender.title(for: .normal)!)
        else { return }

        switch sender {
        case setsButton:
            exercise.sets = newValue

        case repsButton:
            exercise.reps = newValue

        default:
            fatalError("Programmer error, missing case in buttonValueChanged for AddedExercisesTableViewCell")
        }

//        configureForEmptyCount(setsButton, repsButton)

        CoreData.shared.saveViewChanges()
    }

//    private func configureForEmptyCount(_ buttons: SWRoundButton...) {
//        buttons.forEach {
//            $0.backgroundColor = $0.title(for: .normal) == "?" ? .none : .primary // Remove backgroundColor if no value
//        }
//    }
}
