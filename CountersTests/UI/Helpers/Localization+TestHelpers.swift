//
//  Localization+TestHelpers.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation
import XCTest

extension XCTestCase {
    func localized(_ key: String, table: String, bundle: Bundle, file: StaticString = #filePath, line: UInt = #line) -> String {
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
