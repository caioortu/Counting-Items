//
//  String+Localizable.swift
//  Counters
//
//  Created by Caio Ortu on 4/2/21.
//

import Foundation

extension String {
    func localized(tableName: String? = nil, comment: String = "") -> String {
        NSLocalizedString(self, tableName: tableName, comment: comment)
    }
}
