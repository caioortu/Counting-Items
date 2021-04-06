//
//  CountersSearchController.swift
//  Counters
//
//  Created by Caio Ortu on 4/6/21.
//

import UIKit

final class CountersSearchController: UISearchController {
    let resultsController: CountersSearchResultsController
    
    init(resultsController: CountersSearchResultsController) {
        self.resultsController = resultsController
        super.init(searchResultsController: resultsController)
        searchResultsUpdater = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchTerm() {
        guard let term = searchBar.text else { return }
        resultsController.search(term: term)
    }
}

extension CountersSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTerm()
    }
}
