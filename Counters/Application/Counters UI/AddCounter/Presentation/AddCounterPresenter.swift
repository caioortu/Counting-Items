//
//  AddCounterPresenter.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import Foundation

final class AddCounterPresenter {
    private let creator: CounterCreator
    
    var countersView: CountersView?
    var loadingView: CounterLoadingView?
    var errorView: CounterErrorView?
    
    init(creator: CounterCreator) {
        self.creator = creator
    }
    
    func didRequestCounterCreation(title: String?) {
        guard let title = title else { return }
        
        didStartCreatingCounter()
        
        creator.create(title: title) { [weak self] result in
            switch result {
            case let .success(counters):
                self?.didFinishCreatingCounter(with: counters)
                
            case let .failure(error):
                self?.didFinishLoadingCounters(with: error)
            }
        }
    }
    
    private func didStartCreatingCounter() {
        loadingView?.display(CounterLoadingViewModel(isLoading: true))
    }
    
    private func didFinishCreatingCounter(with counters: [Counter]) {
        countersView?.display(CountersViewModel(counters: counters))
        loadingView?.display(CounterLoadingViewModel(isLoading: false))
    }
    
    private func didFinishLoadingCounters(with error: Error) {
        loadingView?.display(CounterLoadingViewModel(isLoading: false))
        errorView?.display(
            .error(
                title: titleForError(error: error),
                message: error.localizedDescription,
                actionTitles: [dismissActionTitle]
            )
        )
    }
}
