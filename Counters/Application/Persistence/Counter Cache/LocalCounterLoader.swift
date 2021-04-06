//
//  LocalCounterLoader.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation

final class LocalCounterLoader {
    private let store: CounterStore
    private let currentDate: () -> Date
    
    init(store: CounterStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalCounterLoader: CounterCache {
    typealias SaveResult = CounterCache.Result

    func save(_ counters: [Counter], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedCounters { [weak self] deletionResult in
            guard let self = self else { return }

            switch deletionResult {
            case .success:
                self.cache(counters, with: completion)

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func cache(_ counters: [Counter], with completion: @escaping (SaveResult) -> Void) {
        store.insert(counters.toLocal(), timestamp: currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }

            completion(insertionResult)
        }
    }
}

extension LocalCounterLoader: CounterLoader {
    typealias LoadResult = CountersResult

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(.some((counters, timestamp))) where CounterCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(counters.toModels()))
            case .success:
                completion(.success([]))
            }
        }
    }
}

private extension Array where Element == Counter {
    func toLocal() -> [LocalCounter] {
        return map { LocalCounter(id: $0.id, title: $0.title, count: $0.count) }
    }
}

private extension Array where Element == LocalCounter {
    func toModels() -> [Counter] {
        return map { Counter(id: $0.id, title: $0.title, count: $0.count) }
    }
}
