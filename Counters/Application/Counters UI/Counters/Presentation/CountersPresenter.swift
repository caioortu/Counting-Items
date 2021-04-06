//
//  CountersPresenter.swift
//  Counters
//
//  Created by Caio Ortu on 4/1/21.
//

import Foundation

final class CountersPresenter {
    private let loader: CounterLoader
    
    let addAction: () -> Void
    
    var countersView: CountersView?
    var loadingView: CounterLoadingView?
    var errorView: CounterErrorView?
    
    init(loader: CounterLoader, addAction: @escaping () -> Void) {
        self.loader = loader
        self.addAction = addAction
    }
    
    func didRequestCountersRefresh() {
        didStartLoadingCounters()
        
        loader.load { [weak self] result in
            switch result {
            case let .success(counters):
                self?.didFinishLoadingCounters(with: counters)
                
            case let .failure(error):
                self?.didFinishLoadingCounters(with: error)
            }
        }
    }
    
    private func didStartLoadingCounters() {
        errorView?.display(.noError)
        loadingView?.display(CounterLoadingViewModel(isLoading: true))
    }
    
    private func didFinishLoadingCounters(with counters: [Counter]) {
        countersView?.display(CountersViewModel(counters: counters))
        loadingView?.display(CounterLoadingViewModel(isLoading: false))
    }
    
    private func didFinishLoadingCounters(with error: Error) {
        loadingView?.display(CounterLoadingViewModel(isLoading: false))
        countersView?.display(CountersViewModel(counters: []))
        errorView?.display(
            .error(
                title: titleForError(error: error),
                message: error.localizedDescription,
                actionTitles: [titleForErrorAction(error: error)],
                actions: [actionForError(error: error)]
            )
        )
    }
    
    private func titleForError(error: Error) -> String {
        switch error as? CountersMapper.Error {
        case .connectivity:
            return connectivityErrorTitle
        case .emptyResult:
            return emptyResultErrorTitle
        default:
            return ""
        }
    }
    
    private func actionForError(error: Error) -> () -> Void {
        switch error as? CountersMapper.Error {
        case .connectivity:
            return didRequestCountersRefresh
        case .emptyResult:
            return addAction
        default:
            return {}
        }
    }
}
