//
//  NSObject+Extension.swift
//  Counters
//
//  Created by Caio Ortu on 4/3/21.
//

import Foundation

extension NSObject {
    class var className: String { String(describing: self) }
    
    var className: String { Self.className }
}
