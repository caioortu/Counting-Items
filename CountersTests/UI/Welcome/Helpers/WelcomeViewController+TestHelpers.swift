//
//  WelcomeViewController+TestHelpers.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import UIKit
@testable import Counters

extension WelcomeViewController {
    var titleText: String? {
        return innerView.titleLabel.text
    }
    
    var subtitleText: String? {
        return innerView.subtitleLabel.text
    }
    
    var primaryActionTitle: String? {
        return innerView.button.attributedTitle(for: .normal)?.string
    }
    
    func featureTitles() -> [String] {
        featureViews().compactMap { $0.titleText }
    }
    
    func featureDescriptions() -> [String] {
        featureViews().compactMap { $0.descriptionText }
    }
    
    private func featureViews() -> [WelcomeFeatureView] {
        return innerView.stackView.arrangedSubviews.compactMap { $0 as? WelcomeFeatureView }
    }
}
