//
//  LoadCountersFromRemoteUseCaseTests.swift
//  CountersTests
//
//  Created by Caio Ortu on 3/29/21.
//

import XCTest
@testable import Counters

class LoadCountersFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromUrl() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromUrlTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_methodIsGet() {
        let (sut, client) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedMethods, [.get])
    }
    
    func test_load_parametesAreEmpty() {
        let (sut, client) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedParameters, [[:]])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = anyNSError()
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnClientNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let sample = [199, 201, 300, 400, 500]
        
        sample.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeCountersJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoCountersOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.emptyResult), when: {
            let emptyListJSON = makeCountersJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversCountersOn200HTTPResponseWithJSONCounters() {
        let (sut, client) = makeSUT()
        
        let counter1 = makeCounter(id: uniqueId())
        
        let counter2 = makeCounter(id: uniqueId(), title: "another counter", count: 2)
        
        let counters = [counter1.model, counter2.model]
        
        expect(sut, toCompleteWith: .success(counters), when: {
            let json = makeCountersJSON([counter1.json, counter2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
         let url = anyURL()
         let client = HTTPClientSpy()
         var sut: RemoteCounterLoader? = RemoteCounterLoader(url: url, client: client)

         var capturedResults = [CountersResult]()
         sut?.load { capturedResults.append($0) }

         sut = nil
         client.complete(withStatusCode: 200, data: makeCountersJSON([]))

         XCTAssertTrue(capturedResults.isEmpty)
     }
    
    // MARK: - Helpers
    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteCounterLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCounterLoader(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteCounterLoader,
                        toCompleteWith expectedResult: CountersResult,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedCounters), .success(expectedCounters)):
                XCTAssertEqual(receivedCounters, expectedCounters, file: file, line: line)
                
            case let (.failure(receivedError as CountersMapper.Error), .failure(expectedError as CountersMapper.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
