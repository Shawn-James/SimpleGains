// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// SWTableView.swift

import UIKit

class SWTableView: UITableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        separatorStyle = .none
        
        backgroundColor = UIColor.Theme.base
    }
}
