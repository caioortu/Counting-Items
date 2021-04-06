//
//  MainQueueDispatchDecorator.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: CounterLoader where T == CounterLoader {
    func load(completion: @escaping (CountersResult) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterOperator where T == CounterOperator {
    func operate(id: String, completion: @escaping (CountersResult) -> Void) {
        decoratee.operate(id: id) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterCreator where T == CounterCreator {
    func create(title: String, completion: @escaping (CountersResult) -> Void) {
        decoratee.create(title: title) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
