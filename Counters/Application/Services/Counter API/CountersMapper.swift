//
//  CountersMapper.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

enum CountersMapper {
    enum Error: Swift.Error {
        case emptyResult
        case connectivity
        case invalidData
    }
    
    static func mappedResult(of data: Data, from response: HTTPURLResponse) -> CountersResult {
        do {
            let counters = try map(data, from: response)
            return .success(counters.toModels())
        } catch {
            return .failure(error)
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteCounter] {
        guard response.statusCode == 200,
              let counters = try? JSONDecoder().decode([RemoteCounter].self, from: data) else {
            throw Error.invalidData
        }
        
        guard !counters.isEmpty else {
            throw Error.emptyResult
        }
        
        return counters
    }
}

private extension Array where Element == RemoteCounter {
    func toModels() -> [Counter] {
        return map { Counter(id: $0.id, title: $0.title ?? "", count: $0.count) }
    }
}
