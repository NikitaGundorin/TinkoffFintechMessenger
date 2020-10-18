//
//  FirestoreDataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 17.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class FirestoreDataProvider: DataProvider {
    
    // MARK: - Private properties
    
    private let networkManager: NetworkManager = FirestoreNetworkManager()
    private let dataManager: DataManager = GCDDataManager()
    private var userId: String?
    
    // MARK: - DataProvider
    
    func subscribeChannels(completion: @escaping ([Channel]?, Error?) -> Void) {
        networkManager.subscribeChannels(completion: completion)
    }
    
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping ([MessageCellModel]?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if self?.userId == nil {
                let group = DispatchGroup()
                group.enter()
                self?.dataManager.getUserId { id in
                    self?.userId = id
                    group.leave()
                }
                group.wait()
            }
            
            self?.networkManager.subscribeMessages(forChannelWithId: channelId) { messages, error in
                guard let messages = messages else {
                    if let error = error {
                        completion(nil, error)
                    }
                    return
                }
                
                let messageModels = messages.map { MessageCellModel(content: $0.content,
                                                                    senderId: $0.senderId,
                                                                    senderName: $0.senderName,
                                                                    userId: self?.userId ?? "") }
                completion(messageModels, nil)
            }
        }
    }
    
    func unsubscriveChannel() {
        networkManager.unsubscribeChannel()
    }
}
