// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SWTableViewCell.swift

import UIKit

class SWTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.SWColor.base.cgColor
        
        backgroundColor = UIColor.SWColor.overlay
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
