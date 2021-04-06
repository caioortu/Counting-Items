//
//  CountersAcceptanceTests.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import XCTest
import UIKit
@testable import Counters

final class CountersAcceptanceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyUserDefaultsState()
    }
    
    override func tearDown() {
        undoUserDefaultsSideEffects()
        
        super.tearDown()
    }
    
    func test_onLaunch_displaysCountersIfWelcomeIsCompleted() throws {
        let userDefaults = TestUserDefaults(welcomeCompleted: true)
        
        try launch(userDefaults: userDefaults)
    }
    
    func test_onAddAction_displaysAddCounter() throws {
        try showAddCounter()
    }

    // MARK: - Helpers
    
    @discardableResult
    private func launch(
        httpClient: HTTPClientStub = .offline,
        userDefaults: UserDefaults = TestUserDefaults(welcomeCompleted: true),
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> CountersViewController {
        let sut = AppDelegate(
            httpClient: httpClient,
            userDefaults: userDefaults
        )
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let viewController = nav?.topViewController as? CountersViewController
        return try XCTUnwrap(viewController, file: file, line: line)
    }
    
    @discardableResult
    private func showAddCounter(
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> AddCounterViewController {
        let counters = try launch(httpClient: .offline)
        
        counters.loadViewIfNeeded()
        counters.simulateAddAction()
        
        let nav = counters.navigationController
        let navAddCounter = nav?.presentedViewController as? UINavigationController
        let addCounter = navAddCounter?.topViewController as? AddCounterViewController
        return try XCTUnwrap(addCounter, file: file, line: line)
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
