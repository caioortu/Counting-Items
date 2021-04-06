//
//  CounterCell+TestHelpers.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit
@testable import Counters

extension CounterCell {
    func simulateIncreaseAction() {
        stepper.value += 1
        stepper.sendActions(for: .valueChanged)
    }
    
    func simulateDecreaseAction() {
        stepper.value -= 1
        stepper.sendActions(for: .valueChanged)
    }
    
    var titleText: String? {
        return titleLabel.text
    }
    
    var countText: String? {
        return countLabel.text
    }
}
