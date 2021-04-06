//
//  UIRefreshControl+TestHelpers.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        sendActions(for: .valueChanged)
    }
}
