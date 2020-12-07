//
//  CoreDataManagerMock.swift
//  MessengerTests
//
//  Created by Nikita Gundorin on 02.12.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

@testable import Messenger
import CoreData

class CoreDataManagerMock: ICoreDataManager {
    
    // MARK: - Public properties
    
    var loadEntities: ((NSManagedObjectContext) -> [NSManagedObject]?)?
    
    // MARK: - Methods calls count
    
    private(set) var performSaveCount = 0
    private(set) var fetchEntitiesCount = 0
    private(set) var updateCount = 0
    private(set) var deleteRangeCount = 0
    
    // MARK: - Recieved props
    
    private(set) var recievedEntityName: String?
    private(set) var recievedPredicate: NSPredicate?
    private(set) var recievedKeyedValues: [String: Any]?
    
    // MARK: - ICoreDataManager
    
    var mainContext: NSManagedObjectContext {
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        performSaveCount += 1
        block(mainContext)
    }
    
    func fetchEntities(withName name: String,
                       inContext context: NSManagedObjectContext,
                       withPredicate predicate: NSPredicate?) -> [NSManagedObject]? {
        fetchEntitiesCount += 1
        recievedEntityName = name
        recievedPredicate = predicate
        return loadEntities?(mainContext)
    }
    
    func update(entityWithName name: String,
                keyedValues: [String: Any],
                inContext context: NSManagedObjectContext,
                predicate: NSPredicate) {
        updateCount += 1
        recievedEntityName = name
        recievedKeyedValues = keyedValues
        recievedPredicate = predicate
    }
    
    func deleteRange(entityName name: String,
                     inContext context: NSManagedObjectContext,
                     predicate: NSPredicate) {
        deleteRangeCount += 1
        recievedEntityName = name
        recievedPredicate = predicate
    }
}
