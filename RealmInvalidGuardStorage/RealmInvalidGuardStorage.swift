//
//  RealmInvalidGuardStorage.swift
//  RealmInvalidGuardStorage
//
//  Created by Bondar Yaroslav on 27/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Realm
import RealmSwift
import PromiseKit

protocol Storable {
    associatedtype MirroredObject: Object
    
    func produce() -> MirroredObject
}

protocol StorableMirror: class {
    associatedtype OriginalObject: Storable
    
    func produce() throws -> OriginalObject
}

class RealmRepo<S: Storable, M: StorableMirror> where S.MirroredObject == M, M.OriginalObject == S {
    private let queue: DispatchQueue
    let config: Realm.Configuration
    let results: Results<M>
    
    init() throws {
        queue = DispatchQueue(label: "sdfsdfds")
        let cfg = Realm.Configuration()
        config = cfg
        let realm = try Realm(configuration: cfg)
        try realm.write {
            realm.deleteAll()
        }
        results = try queue.sync { try Realm(configuration: cfg).objects(M.self) }
    }
    
    var count: Int {
        return queue.sync { results.count }
    }
    
    func save(_ object: S) -> Promise<S> {
        return queue.promise {
            let m = object.produce()
            
            let realm = try Realm(configuration: self.config)
            
            try realm.write {
                realm.add(m, update: true)
            }
            return object
        }
    }
    
    func save(_ objects: [S]) -> Promise<[S]> {
        return queue.promise {
            let m = objects.map { $0.produce() }
            
            let realm = try Realm(configuration: self.config)
            
            try realm.write {
                realm.add(m, update: true)
            }
            return objects
        }
    }
    
    subscript (index: Int) -> S? {
        return try? queue.sync { try self.results[index].produce() }
    }
    
    func get(at index: Int) -> Promise<S> {
        return queue.promise {
            return try Realm(configuration: self.config).objects(M.self)[index].produce()
        }
    }
}
