//
//  FirestoreDataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 17.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Firebase

class FirestoreDataProvider: DataProvider {
    
    // MARK: - Private properties
    
    private let networkManager: NetworkManager = FirestoreNetworkManager()
    private let dataManager: DataManager = GCDDataManager()
    private var userName: String?
    
    // MARK: - Public properties
    
    var userId: String?
    
    // MARK: - DataProvider
    
    func subscribeChannels(completion: @escaping (Error?) -> Void) {
        networkManager.getChannels { [weak self] (channels, error) in
            if let error = error {
                return completion(error)
            }
            
            self?.actualize(channels: channels)
            
            self?.networkManager.subscribeChannels { changes, error in
                guard let changes = changes else {
                    if let error = error {
                        return completion(error)
                    }
                    return
                }
                
                self?.handleChannelsChanges(changes)
                
                completion(nil)
            }
        }
    }
    
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping (Error?) -> Void) {
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
            
            self?.networkManager.getMessages(forChannelWithId: channelId) { (messages, error) in
                if let error = error {
                    return completion(error)
                }
                self?.actualize(messages: messages, channelId: channelId)
                
                self?.networkManager.subscribeMessages(forChannelWithId: channelId) { changes, error in
                    guard let changes = changes else {
                        if let error = error {
                            return completion(error)
                        }
                        return
                    }
                    
                    self?.handleMessagesChanges(changes, channelId: channelId)
                    
                    completion(nil)
                }
            }
        }
    }
    
    func unsubscribeChannel() {
        networkManager.unsubscribeChannel()
    }
    
    func createChannel(withName name: String, completion: @escaping (String) -> Void) {
        networkManager.createChannel(withName: name, completion: completion)
    }
    
    func deleteChannel(withId identifier: String) {
        networkManager.deleteChannel(withId: identifier) { isSuccess in
            CoreDataManager.shared.performSave { context in
                guard isSuccess, let channel = CoreDataManager.shared.fetchEntities(withName: "Channel_db",
                                                                                    inContext: context,
                                                                                    withPredicate: .init(format: "identifier == %@", identifier))?.first as? Channel_db
                    else { return }
                
                context.delete(channel)
            }
        }
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
    
    // MARK: - Private methods
    
    private func actualize(channels: [Channel]?) {
        if let actualIds = channels?.compactMap({ $0.identifier }), !actualIds.isEmpty {
            CoreDataManager.shared.performSave { context in
                CoreDataManager.shared.deleteRange(entityName: "Channel_db",
                                                   inContext: context,
                                                   predicate: .init(format: "NOT identifier IN %@", actualIds))
            }
        }
    }
    
    private func actualize(messages: [Message]?, channelId: String) {
        if let actualIds = messages?.compactMap({ $0.identifier }), !actualIds.isEmpty {
            CoreDataManager.shared.performSave { context in
                CoreDataManager.shared.deleteRange(entityName: "Message_db",
                                                   inContext: context,
                                                   predicate: .init(format: "channel.identifier == %@ AND NOT identifier IN %@", channelId, actualIds))
            }
        }
    }
    
    private func handleChannelsChanges(_ changes: [DocumentChange]) {
        CoreDataManager.shared.performSave { [weak self] context in
            let addedIds = changes.filter { $0.type != .removed }.compactMap { $0.document.documentID }
            let deletedIds = changes.filter { $0.type == .removed }.compactMap { $0.document.documentID }
            if !deletedIds.isEmpty {
                CoreDataManager.shared.deleteRange(entityName: "Channel_db",
                                                   inContext: context,
                                                   predicate: .init(format: "identifier IN %@",
                                                                    deletedIds))
            }
            
            let existingChannels = CoreDataManager.shared.fetchEntities(withName: "Channel_db",
                                                                        inContext: context,
                                                                        withPredicate: .init(format: "identifier IN %@",
                                                                                             addedIds)) as? [Channel_db]
            
            changes.filter { $0.type != .removed }.forEach { change in
                if let channel = Channel(document: change.document) {
                    if let existingChannel = existingChannels?
                        .first(where: { $0.identifier == change.document.documentID }),
                        let dictionary = self?.getUpdatedProperties(ofChannel: channel,
                                                                    existingChannel: existingChannel) {
                        if !dictionary.isEmpty {
                            CoreDataManager.shared.update(entityWithName: "Channel_db",
                                                          keyedValues: dictionary,
                                                          inContext: context,
                                                          predicate: .init(format: "identifier == %@",
                                                                           channel.identifier))
                        }
                    } else {
                        _ = Channel_db(channel: channel, context: context)
                    }
                }
            }
        }
    }
    
    private func handleMessagesChanges(_ changes: [DocumentChange], channelId: String) {
        CoreDataManager.shared.performSave { [weak self] context in
            guard let channel = CoreDataManager.shared.fetchEntities(withName: "Channel_db",
                                                                     inContext: context,
                                                                     withPredicate: .init(format: "identifier == %@", channelId))?.first as? Channel_db
                else { return }
            
            let addedIds = changes.filter { $0.type != .removed }.compactMap { $0.document.documentID }
            let deletedIds = changes.filter { $0.type == .removed }.compactMap { $0.document.documentID }
            
            if !deletedIds.isEmpty {
                CoreDataManager.shared.deleteRange(entityName: "Message_db",
                                                   inContext: context,
                                                   predicate: .init(format: "identifier IN %@", deletedIds))
            }
            
            let existingMessages = CoreDataManager.shared.fetchEntities(withName: "Message_db",
                                                                        inContext: context,
                                                                        withPredicate: .init(format: "identifier IN %@", addedIds)) as? [Message_db]
            var messagesToSave: [Message_db] = []
            changes.filter { $0.type != .removed }.forEach { change in
                if let message = Message(document: change.document) {
                    if let existingMessage = existingMessages?
                        .first(where: { $0.identifier == change.document.documentID }),
                        let dictionary = self?.getUpdatedProperties(ofMessage: message,
                                                                    existingMessage: existingMessage) {
                        if !dictionary.isEmpty {
                            CoreDataManager.shared.update(entityWithName: "Message_db",
                                                          keyedValues: dictionary,
                                                          inContext: context,
                                                          predicate: .init(format: "identifier == %@",
                                                                           message.identifier))
                        }
                    } else {
                        messagesToSave.append(Message_db(message: message, context: context))
                    }
                }
            }
            channel.addToMessages(.init(array: messagesToSave))
        }
    }
    
    private func getUpdatedProperties(ofChannel channel: Channel, existingChannel: Channel_db) -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if channel.name != existingChannel.name {
            dictionary["name"] = channel.name
        }
        if channel.lastMessage != existingChannel.lastMessage {
            dictionary["lastMessage"] = channel.lastMessage
        }
        if channel.lastActivity != existingChannel.lastActivity {
            dictionary["lastActivity"] = channel.lastActivity
        }
        return dictionary
    }
    
    private func getUpdatedProperties(ofMessage message: Message, existingMessage: Message_db) -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if message.content != existingMessage.content {
            dictionary["content"] = message.content
        }
        if message.created != existingMessage.created {
            dictionary["created"] = message.created
        }
        if message.senderId != existingMessage.senderId {
            dictionary["senderId"] = message.senderId
        }
        if message.senderName != existingMessage.senderName {
            dictionary["senderName"] = message.senderName
        }
        
        return dictionary
    }
}
