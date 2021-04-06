//
//  AddCounterPresenter+Localized.swift
//  Counters
//
//  Created by Caio Ortu on 4/5/21.
//

import Foundation

extension AddCounterPresenter {
    private var table: String { "AddCounter" }
    
    var title: String {
        return "ADD_COUNTER_TITLE".localized(tableName: table)
    }
    
    var placeholder: String {
        return "ADD_COUNTER_TEXTFIELD_PLACEHOLDER".localized(tableName: table)
    }
    
    var dismissActionTitle: String {
        "ADD_COUNTER_DISMISS".localized(tableName: table)
    }
    
    func titleForError(error: Error) -> String {
        switch error as? CountersMapper.Error {
        case .connectivity:
            return "CONNECTIVITY_ERROR_TITLE".localized(tableName: table)
        default:
            return ""
        }
    }
}
