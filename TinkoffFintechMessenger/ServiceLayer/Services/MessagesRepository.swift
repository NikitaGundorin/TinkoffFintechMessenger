//
//  MessagesRepository.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import CoreData

class MessagesRepository: Repository<Message_db>, IMessagesRepository {
    
    // MARK: - Private properties
    
    private var userId: String
    
    // MARK: - Initializer
    
    init(coreDataManager: ICoreDataManager,
         fetchRequest: NSFetchRequest<Message_db>,
         userId: String,
         logger: ILogger) {
        self.userId = userId
        super.init(coreDataManager: coreDataManager,
                   fetchRequest: fetchRequest,
                   logger: logger)
    }
    
    // MARK: - IMessagesRepository
    
    func object(at indexPath: IndexPath) -> MessageModel? {
        let message = super.object(at: indexPath)
        return MessageModel(message: message, userId: userId)
    }
    
    func fetchedObjects() -> [MessageModel]? {
        guard let messages = super.fetchedObjects() else { return nil }
        return messages.compactMap { MessageModel(message: $0, userId: userId) }
    }
}
