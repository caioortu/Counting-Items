//
//  CountersMapperError+Localized.swift
//  Counters
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation

extension CountersMapper.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .connectivity:
            return "CONNECTIVITY_ERROR_MESSAGE".localized()
        case .emptyResult:
            return "EMPTY_RESULT_ERROR_MESSAGE".localized()
        default:
            return ""
        }
    }
}
