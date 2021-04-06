//
//  CounterCellPresenter.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import UIKit

final class CounterCellPresenter {
    private let counter: Counter
    private let increaseOperator: CounterOperator
    private let decreaseOperator: CounterOperator
    
    var countersView: CountersView?
    var errorView: CounterErrorView?
    
    private var nextConterCount = 0
    
    init(counter: Counter, increaseOperator: CounterOperator, decreaseOperator: CounterOperator) {
        self.counter = counter
        self.increaseOperator = increaseOperator
        self.decreaseOperator = decreaseOperator
    }
    
    func title() -> String {
        counter.title.isEmpty ? counter.id : counter.title
    }
    
    func countText() -> String {
        "\(counter.count)"
    }
    
    func counterCount() -> Double {
        Double(counter.count)
    }
    
    func countColor() -> UIColor? {
        counter.count > 0 ? .accentColor : .disabledText
    }
    
    func didRequestCounterIncrease() {
        nextConterCount = counter.count + 1
        
        increaseOperator.operate(id: counter.id) { [weak self] result in
            switch result {
            case let .success(counters):
                self?.didFinishLoadingCounters(with: counters)
                
            case let .failure(error):
                self?.didFinishLoadingCounters(with: error)
            }
        }
    }
    
    func didRequestCounterDecrease() {
        nextConterCount = counter.count - 1
        
        decreaseOperator.operate(id: counter.id) { [weak self] result in
            switch result {
            case let .success(counters):
                self?.didFinishLoadingCounters(with: counters)
                
            case let .failure(error):
                self?.didFinishLoadingCounters(with: error)
            }
        }
    }
    
    private func didFinishLoadingCounters(with counters: [Counter]) {
        countersView?.display(CountersViewModel(counters: counters))
    }
    
    private func didFinishLoadingCounters(with error: Error) {
        let retryTitle = "COUNTER_RETRY".localized(tableName: "Counters")
        let dismissTitle = "COUNTER_DISMISS".localized(tableName: "Counters")
        errorView?.display(.error(
                            title: errorTitle(),
                            message: error.localizedDescription,
                            actionTitles: [retryTitle, dismissTitle],
                            actions: [retryAction()]
        ))
    }
    
    private func retryAction() -> () -> Void {
        nextConterCount > counter.count ? didRequestCounterIncrease : didRequestCounterDecrease
    }
    
    private func errorTitle() -> String {
        let format = "COUNTER_OPERATION_ERROR_TITLE".localized(tableName: "Counters")
        return String(format: format, title(), nextConterCount)
    }
}
