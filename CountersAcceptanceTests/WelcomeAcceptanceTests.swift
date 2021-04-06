//
//  WelcomeAcceptanceTests.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import XCTest
import UIKit
@testable import Counters

final class WelcomeAcceptanceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyUserDefaultsState()
    }
    
    override func tearDown() {
        undoUserDefaultsSideEffects()
        
        super.tearDown()
    }
    
    func test_onLaunch_displaysCountersIfWelcomeIsCompleted() throws {
        let userDefaults = TestUserDefaults(welcomeCompleted: false)
        
        try launch(userDefaults: userDefaults)
    }

    // MARK: - Helpers
    
    @discardableResult
    private func launch(
        httpClient: HTTPClientStub = .offline,
        userDefaults: UserDefaults = TestUserDefaults(welcomeCompleted: false),
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> WelcomeViewController {
        let sut = AppDelegate(httpClient: httpClient, userDefaults: userDefaults)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()
        
        let viewController = sut.window?.rootViewController as? WelcomeViewController
        return try XCTUnwrap(viewController, file: file, line: line)
    }
    
    private func setupEmptyUserDefaultsState() {
        deleteUserDefaultsArtifacts()
    }
    
    private func undoUserDefaultsSideEffects() {
        deleteUserDefaultsArtifacts()
    }
    
    private func deleteUserDefaultsArtifacts() {
        TestUserDefaults.removePersistentDomain()
    }
}
