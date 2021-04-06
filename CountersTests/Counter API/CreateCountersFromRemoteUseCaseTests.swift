//
//  CreateCountersFromRemoteUseCaseTests.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/1/21.
//

import XCTest
@testable import Counters

class CreateCountersFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_create_requestsDataFromUrl() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.create(title: anyTitle()) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_createTwice_requestsDataFromUrlTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.create(title: anyTitle()) { _ in }
        sut.create(title: anyTitle()) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_create_methodIsPost() {
        let (sut, client) = makeSUT()
        
        sut.create(title: anyTitle()) { _ in }
        
        XCTAssertEqual(client.requestedMethods, [.post])
    }
    
    func test_create_parametesAreNotEmpty() {
        let title = anyTitle()
        let (sut, client) = makeSUT()
        
        sut.create(title: title) { _ in }
        
        XCTAssertEqual(client.requestedParameters, [["title": title]])
    }
    
    func test_create_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = anyNSError()
            client.complete(with: clientError)
        })
    }
    
    func test_create_deliversErrorOnClientNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let sample = [199, 201, 300, 400, 500]
        
        sample.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeCountersJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_create_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_create_deliversNoCountersOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.emptyResult), when: {
            let emptyListJSON = makeCountersJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_create_deliversCountersOn200HTTPResponseWithJSONCounters() {
        let (sut, client) = makeSUT()
        
        let counter1 = makeCounter(id: uniqueId())
        
        let counter2 = makeCounter(id: uniqueId(), title: "another counter", count: 2)
        
        let counters = [counter1.model, counter2.model]
        
        expect(sut, toCompleteWith: .success(counters), when: {
            let json = makeCountersJSON([counter1.json, counter2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_create_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: RemoteCounterCreator? = RemoteCounterCreator(url: url, client: client)
        
        var capturedResults = [CountersResult]()
        sut?.create(title: anyTitle()) { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeCountersJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteCounterCreator, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCounterCreator(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteCounterCreator,
                        toCompleteWith expectedResult: CountersResult,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for create completion")
        
        sut.create(title: anyTitle()) { receivedResult in
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
