//
//  ConversationNetworkManagerMock.swift
//  MessengerTests
//
//  Created by Nikita Gundorin on 02.12.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

@testable import Messenger
import Foundation
import Firebase

class ConversationNetworkManagerMock: IConversationNetworkManager {
    
    // MARK: - Public properties
    
    var channels: [Channel]?
    var error: Error?
    var documentChanges: [DocumentChange]?
    var messages: [Message]?
    var channelDeleted = false
    
    // MARK: - Methods calls count
    
    private(set) var getChannelsCount = 0
    private(set) var subscribeChannelsCount = 0
    private(set) var getMessagesCount = 0
    private(set) var subscribeMessagesCount = 0
    private(set) var unsubscribeChannelCount = 0
    private(set) var createChannelCount = 0
    private(set) var deleteChannelCount = 0
    private(set) var sendMessageCount = 0
    
    // MARK: - Recieved props
    
    private(set) var recievedChannelId: String?
    private(set) var recievedChannelName: String?
    private(set) var recievedMessageContent: String?
    private(set) var recievedSenderId: String?
    private(set) var recievedSenderName: String?
    
    // MARK: - IConversationNetworkManager
    
    func getChannels(completion: @escaping ([Channel]?, Error?) -> Void) {
        getChannelsCount += 1
        completion(channels, error)
    }
    
    func subscribeChannels(completion: @escaping ([DocumentChange]?, Error?) -> Void) {
        subscribeChannelsCount += 1
        completion(documentChanges, error)
    }
    
    func getMessages(forChannelWithId channelId: String,
                     completion: @escaping ([Message]?, Error?) -> Void) {
        getMessagesCount += 1
        recievedChannelId = channelId
        completion(messages, error)
    }
    
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping ([DocumentChange]?, Error?) -> Void) {
        subscribeMessagesCount += 1
        recievedChannelId = channelId
        completion(documentChanges, error)
    }
    
    func unsubscribeChannel() {
        unsubscribeChannelCount += 1
    }
    
    func createChannel(withName name: String, completion: @escaping (String) -> Void) {
        createChannelCount += 1
        recievedChannelName = name
        completion(name)
    }
    
    func deleteChannel(withId identifier: String, completion: @escaping (Bool) -> Void) {
        deleteChannelCount += 1
        recievedChannelId = identifier
        completion(channelDeleted)
    }
    
    func sendMessage(widthContent content: String,
                     senderId: String,
                     senderName: String,
                     completion: @escaping () -> Void) {
        sendMessageCount += 1
        recievedMessageContent = content
        recievedSenderId = senderId
        recievedSenderName = senderName
        completion()
    }
}
