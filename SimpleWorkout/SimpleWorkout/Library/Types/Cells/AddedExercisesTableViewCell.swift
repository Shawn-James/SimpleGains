// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// AddedExercisesTableViewCell.swift

import UIKit

class AddedExercisesTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet private var weightTextField: UITextField!
    @IBOutlet private var swRoundButtons: [SWRoundButton]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func resetControls() {
        weightTextField.text?.removeAll(keepingCapacity: false)
        
        swRoundButtons.forEach {
            $0.setTitle("?", for: .normal)
        }
    }
}
