//
//  CoreDataCounterStore.swift
//  Counters
//
//  Created by Caio Ortu on 3/30/21.
//

import CoreData

final class CoreDataCounterStore: CounterStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "CounterStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    return CachedCounters(counters: $0.localCounters, timestamp: $0.timestamp)
                }
            })
        }
    }
    
    func insert(_ counters: [LocalCounter], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.counters = ManagedCounter.counters(from: counters, in: context)
                try context.save()
            })
        }
    }
    
    func deleteCachedCounters(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
