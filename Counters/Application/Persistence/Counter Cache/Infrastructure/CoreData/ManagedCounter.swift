//
//  ManagedCounter.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import CoreData

@objc(ManagedCounter)
class ManagedCounter: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var count: Int
    @NSManaged var cache: ManagedCache
}

extension ManagedCounter {
    static func counters(from localCounters: [LocalCounter], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localCounters.map { local in
            let managed = ManagedCounter(context: context)
            managed.id = local.id
            managed.title = local.title
            managed.count = local.count
            
            return managed
        })
    }
    
    var local: LocalCounter {
        return LocalCounter(id: id, title: title, count: count)
    }
}
