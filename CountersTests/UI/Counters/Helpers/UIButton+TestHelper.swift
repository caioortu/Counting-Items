//
//  UIButton+TestHelper.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/5/21.
//

import UIKit

extension UIButton {
    func simulateTap() {
        sendActions(for: .touchUpInside)
    }
}
