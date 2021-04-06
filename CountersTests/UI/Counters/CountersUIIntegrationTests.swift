//
//  CountersUIIntegrationTests.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import XCTest
import UIKit
@testable import Counters

final class CountersUIIntegrationTests: XCTestCase {
    
    func test_countersView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.titleText, localized("COUNTERS_TITLE"))
    }
    
    func test_countersView_hasBottonContedText() {
        let counters = [makeCounter(), makeCounter()]
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCountersLoading(with: counters, at: 0)
        
        let loalizedWithFormat = String(format: localized("COUNTERS_BAR_TITLE"), counters.count, counters.counted)
        XCTAssertEqual(sut.countedMessage, loalizedWithFormat)
    }
    
    func test_loadActions_requestCountersFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCountersCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCountersCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedCountersReload()
        XCTAssertEqual(loader.loadCountersCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedCountersReload()
        XCTAssertEqual(loader.loadCountersCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingIndicator_isVisibleWhileLoadingCounters() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeCountersLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedCountersReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeCountersLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadCompletion_rendersSuccessfullyLoadedCounters() {
        let counter0 = makeCounter(title: "title", count: 3)
        let counter1 = makeCounter(count: 0)
        let counter2 = makeCounter(title: "another title", count: 1)
        let counter3 = makeCounter(count: 10)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeCountersLoading(with: [counter0], at: 0)
        assertThat(sut, isRendering: [counter0])
        
        sut.simulateUserInitiatedCountersReload()
        loader.completeCountersLoading(with: [counter0, counter1, counter2, counter3], at: 1)
        assertThat(sut, isRendering: [counter0, counter1, counter2, counter3])
    }
    
    func test_loadCompletion_rendersErrorViewWithError() {
        let error = anyNSError()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCountersLoadingWithError(at: 0)
        
        XCTAssertTrue(sut.isShowingErrorView)
        XCTAssertEqual(sut.errorViewMessage, error.localizedDescription)
    }
    
    func test_loadCompletion_altersCurrentRenderingStateOnError() {
        let counter0 = makeCounter()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCountersLoading(with: [counter0], at: 0)
        assertThat(sut, isRendering: [counter0])
        XCTAssertFalse(sut.isShowingErrorView)
        XCTAssertTrue(sut.isShowingCountedMessage)
        
        sut.simulateUserInitiatedCountersReload()
        loader.completeCountersLoadingWithError(at: 1)
        assertThat(sut, isRendering: [])
        XCTAssertTrue(sut.isShowingErrorView)
        XCTAssertFalse(sut.isShowingCountedMessage)
    }
    
    func test_operateCompletion_rendersSuccessfullyOperatedCounters() {
        let counter0 = makeCounter(count: 0)
        let counter1 = makeCounter(count: 1)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeCountersLoading(with: [counter0])
        assertThat(sut, isRendering: [counter0])
        
        let view = sut.simulateCounterViewVisible(at: 0)
        view?.simulateIncreaseAction()
        loader.completeCounterOperating(with: [counter1])
        assertThat(sut, isRendering: [counter1])
    }
    
    func test_addAction_isTriggeredWhenTappingAddButton() {
        var addActionCalled = false
        let (sut, _) = makeSUT {
            addActionCalled = true
        }
        
        sut.loadViewIfNeeded()
        sut.simulateAddAction()
        
        XCTAssertTrue(addActionCalled)
    }
    
    func test_addAction_isTriggeredWhenTappingEmptyStateActionButton() {
        let error = CountersMapper.Error.emptyResult
        var addActionCalled = false
        let (sut, loader) = makeSUT {
            addActionCalled = true
        }
        
        sut.loadViewIfNeeded()
        loader.completeCountersLoadingWithError(error: error)
        sut.simulateErrorViewAction()
        
        XCTAssertTrue(addActionCalled)
    }
    
    func test_searchCompletion_rendersSuccessfullySearchedCounters() {
        let counter0 = makeCounter(title: "title", count: 3)
        let counter1 = makeCounter(count: 0)
        let counter2 = makeCounter(title: "another title", count: 1)
        let counter3 = makeCounter(count: 10)
        let term = "another"
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeCountersLoading(with: [counter0], at: 0)
        assertThat(sut, isRendering: [counter0])
        
        sut.simulateSearch(with: term)
        loader.completeCountersLoading(with: [counter0, counter1, counter2, counter3], at: 1)
        assertThat(sut, isRenderingSearched: [counter2])
    }
    
    func test_searchCompletion_rendersErrorViewWithError() {
        let term = anyTerm()
        let error = anyNSError()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCountersLoading(at: 0)
        
        sut.simulateSearch(with: term)
        loader.completeCountersLoadingWithError(at: 1)
        XCTAssertTrue(sut.isShowingSearchErrorView)
        XCTAssertEqual(sut.searchErrorViewMessage, error.localizedDescription)
    }
    
    func test_searchCompletion_rendersErrorViewOnEmptyResult() {
        let term = anyTerm()
        let counter = makeCounter(title: "title")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCountersLoading(at: 0)
        
        sut.simulateSearch(with: term)
        loader.completeCountersLoading(with: [counter], at: 1)
        XCTAssertTrue(sut.isShowingSearchErrorView)
        XCTAssertEqual(sut.searchErrorViewMessage, localized("COUNTER_SEARCH_NO_RESULT"))
    }
    
    func test_loadCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeCountersLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_operateCompletion_dispatchesFromBackgroundToMainThread() {
        let counter = makeCounter()
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeCountersLoading(with: [counter])
        let view = sut.simulateCounterViewVisible(at: 0)
        view?.simulateIncreaseAction()
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeCounterOperating()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        addAction: @escaping () -> Void = { },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CountersViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CountersUIComposer.composedWith(
            loader: loader,
            increaseOperator: loader,
            decreaseOperator: loader,
            addAction: addAction
        )
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private func anyTerm() -> String {
        return "any string"
    }
    
    private func makeCounter(id: String = uniqueId(), title: String = anyTitle(), count: Int = 0) -> Counter {
        return Counter(id: id, title: title, count: count)
    }
}

private extension Array where Element == Counter {
    var counted: Int {
        reduce(0) { $0 + $1.count }
    }
}
