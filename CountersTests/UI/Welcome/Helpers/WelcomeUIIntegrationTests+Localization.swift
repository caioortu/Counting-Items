//
//  WelcomeUIIntegrationTests+Localization.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation
import XCTest
@testable import Counters

extension WelcomeUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        localized(key, table: "Welcome", bundle: Bundle(for: WelcomeViewController.self), file: file, line: line)
    }
}
