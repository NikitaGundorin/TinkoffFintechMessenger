//
//  CoreDataManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Public properties
    
    lazy var didUpdateDatabase: (() -> Void)? = { [weak self] in
        self?.printDatabaseStatistic()
    }
    
    // MARK: - Private properties

    private lazy var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("documents path not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let loggerSourceName = "Core Data"
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private lazy var modelURL = Bundle.main.url(forResource: dataModelName, withExtension: dataModelExtension)
    
    // MARK: - Managed Object Model
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = modelURL, let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("NSManagedObjectModel creation failed")
        }
        return managedObjectModel
    }()
    
    // MARK: - Persistent Store Coordinator
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return coordinator
    }()
    
    // MARK: - Contexts
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                self.performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        
        let block = {
            do {
                try context.save()
                if let parent = context.parent { self.performSave(in: parent) }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        
        if context === writterContext {
            context.perform(block)
        } else {
            context.performAndWait(block)
        }
    }
    
    // MARK: - Fetch Requset
    
    func fetchEntities(withName name: String,
                       inContext context: NSManagedObjectContext,
                       withPredicate predicate: NSPredicate? = nil) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            Logger.error(loggerSourceName, error.localizedDescription)
        }
        return nil
    }
    
    // MARK: - Observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc private func managedObjectContextDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDatabase?()
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            Logger.info(loggerSourceName, "Inserted objects: \(inserts.count)")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            Logger.info(loggerSourceName, "Updated objects: \(updates.count)")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            Logger.info(loggerSourceName, "Deleted objects: \(deletes.count)")
        }
    }
    
    func printDatabaseStatistic() {
        mainContext.perform { [weak self] in
            do {
                if let channelsCount = try self?.mainContext.count(for: Channel_db.fetchRequest()) {
                    Logger.info(self?.loggerSourceName ?? "", "Number of channels: \(channelsCount)")
                }
                if let messagesCount = try self?.mainContext.count(for: Message_db.fetchRequest()) {
                    Logger.info(self?.loggerSourceName ?? "", "Number of messages: \(messagesCount)")
                }
            } catch {
                Logger.error(self?.loggerSourceName ?? "", error.localizedDescription)
            }
        }
    }
}
