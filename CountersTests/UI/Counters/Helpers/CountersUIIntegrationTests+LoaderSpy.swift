//
//  CountersUIIntegrationTests+LoaderSpy.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation
@testable import Counters

extension CountersUIIntegrationTests {
    
    class LoaderSpy: CounterLoader, CounterOperator {
        
        // MARK: - CounterLoader
        
        private var countersRequests = [(CountersResult) -> Void]()
        
        var loadCountersCallCount: Int {
            return countersRequests.count
        }
        
        func load(completion: @escaping (CountersResult) -> Void) {
            countersRequests.append(completion)
        }
        
        func completeCountersLoading(with counters: [Counter] = [], at index: Int = 0) {
            countersRequests[index](.success(counters))
        }
        
        func completeCountersLoadingWithError(error: Error = anyNSError(), at index: Int = 0) {
            countersRequests[index](.failure(error))
        }
        
        // MARK: - CounterOperator
        
        private var operationRequests = [(CountersResult) -> Void]()
        
        var operateCounterCallCount: Int {
            return operationRequests.count
        }
        
        func operate(id: String, completion: @escaping (CountersResult) -> Void) {
            operationRequests.append(completion)
        }
        
        func completeCounterOperating(with counters: [Counter] = [], at index: Int = 0) {
            operationRequests[index](.success(counters))
        }
        
        func completeCounterOperatingWithError(error: Error = anyNSError(), at index: Int = 0) {
            operationRequests[index](.failure(error))
        }
    }
}
