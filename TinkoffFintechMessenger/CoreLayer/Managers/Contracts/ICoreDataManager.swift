//
//  ICoreDataManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 08.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import CoreData

protocol ICoreDataManager {
    var mainContext: NSManagedObjectContext { get }
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    
    func fetchEntities(withName name: String,
                       inContext context: NSManagedObjectContext,
                       withPredicate predicate: NSPredicate?) -> [NSManagedObject]? 
    func update(entityWithName name: String,
                keyedValues: [String: Any],
                inContext context: NSManagedObjectContext,
                predicate: NSPredicate)
    func deleteRange(entityName name: String,
                     inContext context: NSManagedObjectContext,
                     predicate: NSPredicate)
}
