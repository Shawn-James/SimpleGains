// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleDetailCell.swift

import UIKit

final class ScheduleDetailCell: CustomCell, ReusableView {
    // MARK: - Public Properties

    /// Injected object used to configure this cell
    var exercise: Exercise? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Private Properties

    /// Holds the name of the scheduled exercise
    @IBOutlet private var nameLabel: UILabel!

    /// Static label for weight
    @IBOutlet private var weightLabel: UILabel!

    /// Holds the weight for the scheduled exercise
    @IBOutlet private var weightTextField: UITextField!

    /// Static label for sets
    @IBOutlet private var setsLabel: UILabel!

    /// The button used to edit the sets count property of the scheduled exercise
    @IBOutlet private var setsButton: CircleButton!

    /// Static label for sets
    @IBOutlet private var repsLabel: UILabel!

    /// The button used to manipulate the reps count property of the scheduled exercise
    @IBOutlet private var repsButton: CircleButton!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        weightLabel.textColor = UIColor.CustomColor.lightText
        setsLabel.textColor = UIColor.CustomColor.lightText
        repsLabel.textColor = UIColor.CustomColor.lightText
    }

    // MARK: - Public Methods

    /// Used to reset the button titles and their respective properties back to `1`, assuming the user has passed the desired amount
    public func resetButtonValues() {
        guard let exercise = exercise else { return }

        exercise.sets = 1; setsButton.setTitle("1", for: .normal)
        exercise.reps = 1; repsButton.setTitle("1", for: .normal)
    }

    // MARK: - Private Methods

    /// Saves the new weight found in the textfield after the user has finished editing
    /// - Parameter sender: The numberTextfield that was being edited
    @IBAction private func TextFieldEditingDidEnd(_ sender: NumberTextField) {
        guard
            let exercise = exercise,
            let newValue = Int16(sender.text!)
        else { return }

        switch sender {
        case weightTextField:
            exercise.weight = newValue

        default:
            fatalError("Programmer error, missing case in textFieldEditingDidEnd for ScheduleDetailCell")
        }

        CoreDataManager.shared.saveViewChanges()
    }

    /// Handles button taps, sets the respective property to be the amount found on the button title
    /// - Parameter sender: The button that was tapped
    @IBAction private func buttonValueChanged(_ sender: CircleButton) {
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
            fatalError("Programmer error, missing case in buttonValueChanged for ScheduleDetailCell")
        }

        CoreDataManager.shared.saveViewChanges()
    }

    /// Configures the cell using the injected object
    private func updateViews() {
        if let exercise = exercise {
            nameLabel.text = exercise.name

            weightTextField.text = exercise.weight != 0 ?
                "\(exercise.weight)" : "" // Empty string intentionally defaults to placeholder

            exercise.sets != 0 ?
                setsButton.setTitle("\(exercise.sets)", for: .normal) : setsButton.setTitle("1", for: .normal)

            exercise.reps != 0 ?
                repsButton.setTitle("\(exercise.reps)", for: .normal) : repsButton.setTitle("1", for: .normal)
        }
    }
}
