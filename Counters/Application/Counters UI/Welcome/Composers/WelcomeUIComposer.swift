//
//  WelcomeUIComposer.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

enum WelcomeUIComposer {
    static func compose(primaryAction: @escaping () -> Void = {}) -> WelcomeViewController {
        let presenter = WelcomeViewPresenter()
        let welcomeViewController = WelcomeViewController(presenter: presenter, primaryAction: primaryAction)
        
        return welcomeViewController
    }
}
