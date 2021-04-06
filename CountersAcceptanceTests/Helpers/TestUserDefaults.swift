//
//  TestUserDefaults.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation
@testable import Counters

class TestUserDefaults: UserDefaults {
    
    init(welcomeCompleted: Bool = true) {
        super.init(suiteName: Self.suiteName())!
        self.welcomeCompleted = welcomeCompleted
    }
    
    static func removePersistentDomain() {
        UserDefaults().removePersistentDomain(forName: Self.suiteName())
    }
    
    private static func suiteName() -> String {
        return "\(type(of: self))"
    }
}
