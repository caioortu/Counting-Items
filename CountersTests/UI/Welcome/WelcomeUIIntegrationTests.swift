//
//  WelcomeUIIntegrationTests.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/2/21.
//

import XCTest
import UIKit
@testable import Counters

final class WelcomeUIIntegrationTests: XCTestCase {
    
    func test_welcomeView_hasTitle() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.titleText, localized("WELCOME_TITLE"))
    }
    
    func test_welcomeView_hasSubtitle() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.subtitleText, localized("WELCOME_DESCRIPTION"))
    }
    
    func test_welcomeView_hasTitleForAllFeatures() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        let titles = sut.featureTitles()
        
        XCTAssertEqual(
            titles,
            [localized("WELCOME_ADD_FEATURE_TITLE"),
             localized("WELCOME_COUNT_SHARE_FEATURE_TITLE"),
             localized("WELCOME_COUNT_FEATURE_TITLE")]
        )
    }
    
    func test_welcomeView_hasDescriptionForAllFeatures() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        let descriptions = sut.featureDescriptions()
        
        XCTAssertEqual(
            descriptions,
            [localized("WELCOME_ADD_FEATURE_DESCRIPTION"),
             localized("WELCOME_COUNT_SHARE_FEATURE_DESCRIPTION"),
             localized("WELCOME_COUNT_FEATURE_DESCRIPTION")]
        )
    }
    
    func test_welcomeView_hasPrimaryActionTitle() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.primaryActionTitle, localized("WELCOME_PRIMARY_ACTION_TITLE"))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> WelcomeViewController {
        let sut = WelcomeUIComposer.compose()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
