//
//  CounterCacheTestHelpers.swift
//  CountersTests
//
//  Created by Caio Ortu on 3/30/21.
//

import Foundation
@testable import Counters

func uniqueCounter() -> Counter {
    return Counter(id: UUID().uuidString, title: "some title", count: 0)
}

func uniqueCounters() -> (models: [Counter], local: [LocalCounter]) {
    let models = [uniqueCounter(), uniqueCounter()]
    let local = models.map { LocalCounter(id: $0.id, title: $0.title, count: $0.count) }
    return (models, local)
}

extension Date {
    func minusCounterCacheMaxAge() -> Date {
        return adding(days: -counterCacheMaxAgeInDays)
    }
    
    private var counterCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
