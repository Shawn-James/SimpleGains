// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AddedExercisesTableViewCell.swift

import UIKit

class AddedExercisesTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var setsCount: UILabel!
    @IBOutlet var repsCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func handleSteppers(_ sender: UIStepper) {
        let setsStepper = 0; let repsStepper = 1

        switch sender.tag {
        case setsStepper:
            setsCount.text = String(Int(sender.value))
        case repsStepper:
            repsCount.text = String(Int(sender.value))
        default:
            fatalError("Programmer error: missing tag for stepper")
        }
    }
}
