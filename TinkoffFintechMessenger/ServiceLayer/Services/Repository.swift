//
//  Repository.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 11.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import CoreData

class Repository<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
    
    // MARK: - Private properties
    
    private let logger: ILogger
    private let fetchRequest: NSFetchRequest<T>
    private let coreDataManager: ICoreDataManager
    private var willChangeContentCallback: (() -> Void)?
    private var didChangeContentCallback: (() -> Void)?
    private var dataInsertedCallback: ((IndexPath?) -> Void)?
    private var dataMovedCallback: ((IndexPath?, IndexPath?) -> Void)?
    private var dataUpdatedCallback: ((IndexPath?) -> Void)?
    private var dataDeletedCallback: ((IndexPath?) -> Void)?
    private lazy var fetchedResultsController: NSFetchedResultsController<T> = {
        fetchRequest.resultType = .managedObjectResultType
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataManager.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    // MARK: - Initializer
    
    init(coreDataManager: ICoreDataManager,
         fetchRequest: NSFetchRequest<T>,
         logger: ILogger) {
        self.coreDataManager = coreDataManager
        self.fetchRequest = fetchRequest
        self.logger = logger
    }
    
    // MARK: - Public methods
    
    // Да, это оверхэд, но по-другому frc не отделить от presentation layer
    func configure(willChangeContentCallback: (() -> Void)?,
                   didChangeContentCallback: (() -> Void)?,
                   dataInsertedCallback: ((IndexPath?) -> Void)?,
                   dataMovedCallback: ((IndexPath?, IndexPath?) -> Void)?,
                   dataUpdatedCallback: ((IndexPath?) -> Void)?,
                   dataDeletedCallback: ((IndexPath?) -> Void)?) {
        self.willChangeContentCallback = willChangeContentCallback
        self.didChangeContentCallback = didChangeContentCallback
        self.dataInsertedCallback = dataInsertedCallback
        self.dataMovedCallback = dataMovedCallback
        self.dataUpdatedCallback = dataUpdatedCallback
        self.dataDeletedCallback = dataDeletedCallback
    }
    
    func performFetch(completion: (Error?) -> Void) {
        do {
            try fetchedResultsController.performFetch()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func object(at indexPath: IndexPath) -> T {
        fetchedResultsController.object(at: indexPath)
    }
    
    func fetchedObjects() -> [T]? {
        fetchedResultsController.fetchedObjects
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        willChangeContentCallback?()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChangeContentCallback?()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            dataInsertedCallback?(newIndexPath)
        case .move:
            dataMovedCallback?(indexPath, newIndexPath)
        case .update:
            dataUpdatedCallback?(indexPath)
        case .delete:
            dataDeletedCallback?(indexPath)
        @unknown default:
            logger.info("Unknown case statement")
        }
    }
}
