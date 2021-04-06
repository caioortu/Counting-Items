//
//  XCTestCase+CounterStoreSpecs.swift
//  CountersTests
//
//  Created by Caio Ortu on 3/30/21.
//

import XCTest
@testable import Counters

extension CounterStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        let counters = uniqueCounters().local
        let timestamp = Date()
        
        insert((counters, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedCounters(counters: counters, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        let counters = uniqueCounters().local
        let timestamp = Date()
        
        insert((counters, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedCounters(counters: counters, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueCounters().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueCounters().local, Date()), to: sut)
        
        let insertionError = insert((uniqueCounters().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueCounters().local, Date()), to: sut)
        
        let latestCounters = uniqueCounters().local
        let latestTimestamp = Date()
        insert((latestCounters, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedCounters(counters: latestCounters, timestamp: latestTimestamp)), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueCounters().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueCounters().local, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatSideEffectsRunSerially(on sut: CounterStore, file: StaticString = #filePath, line: UInt = #line) {
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueCounters().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedCounters { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueCounters().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order", file: file, line: line)
    }
}

extension CounterStoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (counters: [LocalCounter], timestamp: Date), to sut: CounterStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.counters, timestamp: cache.timestamp) { result in
            if case let .failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: CounterStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedCounters { result in
            if case let .failure(error) = result { deletionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(
        _ sut: CounterStore,
        toRetrieveTwice expectedResult: CounterStore.RetrievalResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(
        _ sut: CounterStore,
        toRetrieve expectedResult: CounterStore.RetrievalResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                 (.failure, .failure):
                break
                
            case let (.success(.some((expectedCounters, expectedTimestamp))), .success(.some((retrievedCounters, retrievedTimestamp)))):
                XCTAssertEqual(retrievedCounters, expectedCounters, file: file, line: line)
                XCTAssertEqual(retrievedTimestamp, expectedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
