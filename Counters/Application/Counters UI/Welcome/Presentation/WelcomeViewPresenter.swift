//
//  WelcomeViewPresenter.swift
//  Counters
//
//

import UIKit

internal final class WelcomeViewPresenter {
    private let table = "Welcome"
    
    private lazy var features: [WelcomeFeatureView.ViewModel] = [
        .init(
            badge: UIImage.badge(sytemIcon: "42.circle.fill",
                                 color: .appRed),
            title: "WELCOME_ADD_FEATURE_TITLE".localized(tableName: table),
            subtitle: "WELCOME_ADD_FEATURE_DESCRIPTION".localized(tableName: table)
        ),
        .init(
            badge: UIImage.badge(sytemIcon: "person.2.fill",
                                 color: .appYellow),
            title: "WELCOME_COUNT_SHARE_FEATURE_TITLE".localized(tableName: table),
            subtitle: "WELCOME_COUNT_SHARE_FEATURE_DESCRIPTION".localized(tableName: table)
        ),
        .init(
            badge: UIImage.badge(sytemIcon: "lightbulb.fill",
                                 color: .appGreen),
            title: "WELCOME_COUNT_FEATURE_TITLE".localized(tableName: table),
            subtitle: "WELCOME_COUNT_FEATURE_DESCRIPTION".localized(tableName: table)
        )]
}

extension WelcomeViewPresenter: WelcomeViewControllerPresenter {
    var viewModel: WelcomeView.ViewModel {
        
        let welcome = NSMutableAttributedString(string: "WELCOME_TITLE".localized(tableName: table))
        let range = (welcome.string as NSString).range(of: "APP_NAME".localized(tableName: table))
        if let color = UIColor.accentColor, range.location != NSNotFound {
            welcome.setAttributes([.foregroundColor: color], range: range)
        }
        
        return .init(title: welcome,
                     description: "WELCOME_DESCRIPTION".localized(tableName: table),
                     features: features,
                     buttonTitle: "WELCOME_PRIMARY_ACTION_TITLE".localized(tableName: table))
    }
}
