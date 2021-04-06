//
//  CountersSearchPresenter.swift
//  Counters
//
//  Created by Caio Ortu on 4/6/21.
//

import Foundation

protocol CountersSearchView {
    func displaySearch(_ viewModel: CountersViewModel)
}

final class CountersSearchPresenter {
    private let loader: CounterLoader
    
    var searchView: CountersSearchView?
    var errorView: CounterErrorView?
    
    init(loader: CounterLoader) {
        self.loader = loader
    }
    
    func didRequestCountersSearch(term: String) {
        guard !term.isEmpty else { return }
        
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(counters):
                let filteredCounters = counters.filter { $0.title.contains(term) }
                
                guard !filteredCounters.isEmpty else {
                    self.didFinishLoadingCounters(errorMessage: self.noResultError)
                    return
                }
                
                self.didFinishLoadingCounters(with: filteredCounters)
                
            case let .failure(error):
                self.didFinishLoadingCounters(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func didFinishLoadingCounters(with counters: [Counter]) {
        errorView?.display(.noError)
        searchView?.displaySearch(CountersViewModel(counters: counters))
    }
    
    private func didFinishLoadingCounters(errorMessage: String) {
        searchView?.displaySearch(CountersViewModel(counters: []))
        errorView?.display(.error(message: errorMessage))
    }
    
    private var noResultError: String {
        "COUNTER_SEARCH_NO_RESULT".localized(tableName: "Counters")
    }
}
