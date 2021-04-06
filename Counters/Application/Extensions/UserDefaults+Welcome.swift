//
//  UserDefaults+Welcome.swift
//  Counters
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation

extension UserDefaults {
    var welcomeCompleted: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
