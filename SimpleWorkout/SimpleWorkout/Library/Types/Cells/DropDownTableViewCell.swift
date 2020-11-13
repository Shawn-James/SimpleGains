// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// DropDownTableViewCell.swift

import UIKit

class DropDownTableViewCell: UITableViewCell, ReusableView {
    public func configureCell(withAutoCompleteSuggestion autoCompleteSuggestion: NSAttributedString) {
        textLabel?.attributedText = autoCompleteSuggestion
        
        backgroundColor = .secondarySystemBackground
        
        //            highlight color:
        //            let highlightColor = UIView(); highlightColor.backgroundColor = UIColor(named: "AccentColor")
        //            cell.selectedBackgroundView = highlightColor
    }
}
