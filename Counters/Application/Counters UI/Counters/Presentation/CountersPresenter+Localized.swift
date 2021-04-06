//
//  CountersPresenter+Localized.swift
//  Counters
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation

extension CountersPresenter {
    private var table: String { "Counters" }
    
    var title: String {
        return "COUNTERS_TITLE".localized(tableName: table)
    }
    
    var connectivityErrorTitle: String {
        return "CONNECTIVITY_ERROR_TITLE".localized(tableName: table)
    }
    
    var emptyResultErrorTitle: String {
        return "EMPTY_RESULT_ERROR_TITLE".localized(tableName: table)
    }
    
    func titleForErrorAction(error: Error) -> String {
        switch error as? CountersMapper.Error {
        case .connectivity:
            return "COUNTER_RETRY".localized(tableName: table)
        case .emptyResult:
            return "COUNTER_CREATE".localized(tableName: table)
        default:
            return ""
        }
    }
    
    func countedCounter(_ counters: [Counter]) -> String {
        guard !counters.isEmpty else { return "" }
        
        let itemsCount = counters.count
        let counted = counters.reduce(0) { $0 + $1.count }
        let format = "COUNTERS_BAR_TITLE".localized(tableName: table)
        
        return String.localizedStringWithFormat(format, itemsCount, counted)
    }
}
