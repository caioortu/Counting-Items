//
//  DeleteCountersFromRemoteUseCaseTests.swift
//  CountersTests
//
//  Created by Caio Ortu on 4/5/21.
//

import XCTest
@testable import Counters

class DeleteCountersFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_delete_requestsDataFromUrl() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.delete(id: uniqueId()) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_deleteTwice_requestsDataFromUrlTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.delete(id: uniqueId()) { _ in }
        sut.delete(id: uniqueId()) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_delete_methodIsDelete() {
        let (sut, client) = makeSUT()
        
        sut.delete(id: uniqueId()) { _ in }
        
        XCTAssertEqual(client.requestedMethods, [.delete])
    }
    
    func test_delete_parametesAreNotEmpty() {
        let id = uniqueId()
        let (sut, client) = makeSUT()
        
        sut.delete(id: id) { _ in }
        
        XCTAssertEqual(client.requestedParameters, [["id": id]])
    }
    
    func test_delete_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = anyNSError()
            client.complete(with: clientError)
        })
    }
    
    func test_delete_deliversErrorOnClientNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let sample = [199, 201, 300, 400, 500]
        
        sample.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeCountersJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_delete_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_delete_deliversNoCountersOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.emptyResult), when: {
            let emptyListJSON = makeCountersJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_delete_deliversCountersOn200HTTPResponseWithJSONCounters() {
        let (sut, client) = makeSUT()
        
        let counter1 = makeCounter(id: uniqueId())
        
        let counter2 = makeCounter(id: uniqueId(), title: "another counter", count: 2)
        
        let counters = [counter1.model, counter2.model]
        
        expect(sut, toCompleteWith: .success(counters), when: {
            let json = makeCountersJSON([counter1.json, counter2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_delete_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: RemoteCounterDeleter? = RemoteCounterDeleter(url: url, client: client)
        
        var capturedResults = [CountersResult]()
        sut?.delete(id: uniqueId()) { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeCountersJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteCounterDeleter, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCounterDeleter(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteCounterDeleter,
                        toCompleteWith expectedResult: CountersResult,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for delete completion")
        
        sut.delete(id: uniqueId()) { receivedResult in
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

