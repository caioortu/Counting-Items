//
//  CountersUIIntegrationTests+Localization.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation
import XCTest
@testable import Counters

extension CountersUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        localized(key, table: "Counters", bundle: Bundle(for: CountersViewController.self), file: file, line: line)
    }
}
