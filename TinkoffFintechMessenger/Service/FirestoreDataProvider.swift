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
    private var userName: String?
    
    // MARK: - DataProvider
    
    func subscribeChannels(completion: @escaping ([Channel]?, Error?) -> Void) {
        networkManager.subscribeChannels { channels, error in
            guard let channels = channels else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            CoreDataManager.shared.performSave { context in
                channels.forEach { _ = Channel_db(channel: $0, context: context) }
            }
            completion(channels, nil)
        }
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
                group.enter()
                self?.dataManager.loadPersonData(completion: { person in
                    self?.userName = person?.fullName
                    group.leave()
                })
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
                
                CoreDataManager.shared.performSave { context in
                    guard let channel = CoreDataManager.shared.fetchEntities(withName: "Channel_db",
                                                                             inContext: context,
                                                                             withPredicate: .init(format: "identifier == %@", channelId))?.first as? Channel_db
                        else { return }
                    
                    let messagesToSave = messages.map { Message_db(message: $0, context: context) }
                    channel.addToMessages(.init(array: messagesToSave))
                }
                
                completion(messageModels, nil)
            }
        }
    }
    
    func unsubscribeChannel() {
        networkManager.unsubscribeChannel()
    }
    
    func createChannel(withName name: String, completion: @escaping (String) -> Void) {
        networkManager.createChannel(withName: name, completion: completion)
    }
    
    func sendMessage(widthContent content: String, completion: @escaping () -> Void) {
        guard let userId = userId,
            let userName = userName else {
            
                return
        }
        networkManager.sendMessage(widthContent: content,
                                   senderId: userId,
                                   senderName: userName,
                                   completion: completion)
    }
}
