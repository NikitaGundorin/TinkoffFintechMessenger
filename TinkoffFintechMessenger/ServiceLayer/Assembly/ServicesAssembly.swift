//
//  ServicesAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import CoreData

class ServicesAssembly: IServicesAssembly {
    
    // MARK: - Private properties
    
    private let coreAssembly: ICoreAssembly
    
    // MARK: - Initializer
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    // MARK: - IServicesAssembly
    
    func conversationsDataProvider() -> IConversationsDataProvider {
        let dataProvider = FirestoreDataProvider(networkManager: coreAssembly.conversationNetworkManager(),
                                                 userDataProvider: gcdUserDataProvider(),
                                                 coreDataManager: coreAssembly.coreDataManager())
        return dataProvider
    }
    
    func gcdUserDataProvider() -> IUserDataProvider {
        return GCDUserDataProvider(dataManager: coreAssembly.dataManager())
    }
    
    func operationUserDataProvider() -> IUserDataProvider {
        return OperationUserDataProvider(dataManager: coreAssembly.dataManager())
    }
    
    func themeService() -> IThemeService {
        return Appearance.shared
    }
    
    func channelsRepository() -> IChannelsRepository {
        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        fetchRequest.sortDescriptors = [.init(key: "lastActivity", ascending: false),
                                        .init(key: "name", ascending: true)]
        fetchRequest.resultType = .managedObjectResultType
        return ChannelsRepository(coreDataManager: coreAssembly.coreDataManager(),
                                  fetchRequest: fetchRequest,
                                  logger: coreAssembly.logger(sourceName: "ChannelsRepository"))
    }
    
    func messagesRepository(channelId: String, userId: String) -> IMessagesRepository {
        let fetchRequest: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        fetchRequest.sortDescriptors = [.init(key: "created", ascending: true)]
        fetchRequest.predicate = .init(format: "channel.identifier == %@", channelId)
        fetchRequest.resultType = .managedObjectResultType
        return MessagesRepository(coreDataManager: coreAssembly.coreDataManager(),
                                  fetchRequest: fetchRequest,
                                  userId: userId,
                                  logger: coreAssembly.logger(sourceName: "ChannelsRepository"))
    }
    
    func loggerService(sourceName: String) -> ILoggerService {
        return LoggerService(logger: coreAssembly.logger(sourceName: sourceName))
    }
    
    func imagesService() -> IImagesService {
        return PixabayService(networkManager: coreAssembly.networkManager())
    }
}
