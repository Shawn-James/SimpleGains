// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// CircleButton.swift

import UIKit

/// The circular shaped button used throughout the app. Represent the reps and sets properties for exercises
final class CircleButton: CustomButton {
    // MARK: - Public Properties

    var repsCount: Int16?

    // MARK: - Lifecycle

    /// The initializer called directly by the Developer
    convenience init(repsCount: Int16?) {
        self.init()

        self.repsCount = repsCount

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 40).isActive = true
    }

    /// Programmatic init
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = nil
        addTarget(self, action: #selector(handleWorkingRepButtonPress), for: .touchUpInside)
    }

    /// Storyboard init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = UIColor.CustomColor.primary
        addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.size.height / 2
    }

    /// The standard handler used in the ScheduleDetailViewController for actually editing the objects value
    @objc private func handleButtonPress() { // FIXME: - Limit sets to max 5
        let currentValue = Int(title(for: .normal) ?? "0") ?? 0
        var newValue = currentValue

        /// An Int representing the tag number for each button. Requires matching value in the storyboard
        enum Tag: Int {
            case setsButton
            case repsButton
        }

        let maxSetsCount = 5
        let maxRepsCount = 99

        switch tag {
        case Tag.setsButton.rawValue:
            if currentValue != maxSetsCount {
                newValue = currentValue + 1
            }

        case Tag.repsButton.rawValue:
            if currentValue != maxRepsCount {
                newValue = currentValue + 1
            }

        default: fatalError("Programmer error, check storyboard tags for sets/reps button")
        }

        setTitle(String(newValue), for: .normal)
    }

    /// The alternate handler used in the WorkoutViewController used only to display working reps
    @objc private func handleWorkingRepButtonPress() {
        guard
            let repsCount = repsCount,
            repsCount != 0
        else { return }

        switch title(for: .normal) {
        case nil:
            backgroundColor = UIColor.CustomColor.primary
            setTitle(String(repsCount), for: .normal)

        case "1":
            backgroundColor = nil
            setTitle(nil, for: .normal)

        default:
            if let currentValue = Int(title(for: .normal)!) {
                let newValue = currentValue - 1
                setTitle(String(newValue), for: .normal)
            }
        }
    }
}
