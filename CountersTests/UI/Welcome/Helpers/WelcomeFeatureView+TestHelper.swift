//
//  WelcomeFeatureView+TestHelper.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import UIKit
@testable import Counters

extension WelcomeFeatureView {
    var titleText: String? {
        return titleLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
}
