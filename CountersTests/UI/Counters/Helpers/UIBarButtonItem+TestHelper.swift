//
//  UIBarButtonItem+TestHelper.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/5/21.
//

import UIKit

extension UIBarButtonItem {
    func simulateTap() {
        _ = target?.perform(action)
    }
}
