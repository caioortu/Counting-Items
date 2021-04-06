//
//  CountersUIIntegrationTests+Assertions.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import XCTest
@testable import Counters

extension CountersUIIntegrationTests {
    
    func assertThat(
        _ sut: CountersViewController,
        isRendering counters: [Counter],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedCounterViews() == counters.count else {
            return XCTFail("Expected \(counters.count) counters, got \(sut.numberOfRenderedCounterViews()) instead.", file: file, line: line)
        }
        
        counters.enumerated().forEach { index, counter in
            assertThat(sut, hasViewConfiguredFor: counter, at: index, file: file, line: line)
        }
    }
    
    func assertThat(
        _ sut: CountersViewController,
        isRenderingSearched counters: [Counter],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard sut.numberOfSearchedCounterViews() == counters.count else {
            return XCTFail("Expected \(counters.count) counters, got \(sut.numberOfSearchedCounterViews()) instead.", file: file, line: line)
        }
        
        counters.enumerated().forEach { index, counter in
            assertThat(sut, hasViewConfiguredForSearched: counter, at: index, file: file, line: line)
        }
    }
    
    func assertThat(
        _ sut: CountersViewController,
        hasViewConfiguredFor counter: Counter,
        at index: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let view = sut.counterView(at: index)
        
        compare(view: view, with: counter, referenceIndex: index, file: file, line: line)
    }
    
    func assertThat(
        _ sut: CountersViewController,
        hasViewConfiguredForSearched counter: Counter,
        at index: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let view = sut.searchedCounterView(at: index)
        
        compare(view: view, with: counter, referenceIndex: index, file: file, line: line)
    }
    
    private func compare(
        view: UITableViewCell?,
        with counter: Counter,
        referenceIndex index: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let cell = view as? CounterCell else {
            return XCTFail("Expected \(CounterCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.titleText, counter.title, "Expected title text to be \(String(describing: counter.title)) for counter view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.countText, String(counter.count), "Expected count text to be \(String(describing: counter.count)) for counter view at index (\(index))", file: file, line: line)
    }
    
}
