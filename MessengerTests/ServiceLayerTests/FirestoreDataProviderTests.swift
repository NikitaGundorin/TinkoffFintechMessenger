//
//  FirestoreDataProviderTests.swift
//  MessengerTests
//
//  Created by Nikita Gundorin on 02.12.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import XCTest
import Firebase
@testable import Messenger

class FirestoreDataProviderTests: XCTestCase {

    func testSubscribeChannelsSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        let expectation = self.expectation(description: "Subscribing channels")
        var recievedError: Error?
        dataProvider.subscribeChannels { error in
            recievedError = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertNil(recievedError)
        XCTAssertEqual(conversationNetworkManagerMock.getChannelsCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.subscribeChannelsCount, 1)
    }
    
    func testSubscribeChannelsWithExistingChannelsSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                 userDataProvider: userDataProviderMock,
                                                 coreDataManager: coreDataManagerMock)
        conversationNetworkManagerMock.channels = [.init(identifier: "1",
                                                         name: "Channel",
                                                         lastMessage: nil,
                                                         lastActivity: nil),
                                                   .init(identifier: "2",
                                                   name: "Channel2",
                                                   lastMessage: nil,
                                                   lastActivity: nil)
        ]
        let expectation = self.expectation(description: "Subscribing channels")
        var recievedError: Error?
        
        // Act
        dataProvider.subscribeChannels { error in
            recievedError = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertNil(recievedError)
        XCTAssertEqual(conversationNetworkManagerMock.getChannelsCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.subscribeChannelsCount, 1)
        XCTAssertEqual(coreDataManagerMock.performSaveCount, 1)
        XCTAssertEqual(coreDataManagerMock.deleteRangeCount, 1)
        XCTAssertEqual(coreDataManagerMock.recievedEntityName, "Channel_db")
        XCTAssertEqual(coreDataManagerMock.recievedPredicate, NSPredicate(format: "NOT identifier IN %@", ["1", "2"]))
    }
    
    func testSubscribeMessagesSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        let channelId = "1"
        let expectation = self.expectation(description: "Subscribing messages")
        var recievedError: Error?
        
        // Act
        dataProvider.subscribeMessages(forChannelWithId: channelId) { error in
            recievedError = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertNil(recievedError)
        XCTAssertEqual(userDataProviderMock.getUserIdCount, 1)
        XCTAssertEqual(userDataProviderMock.loadUserDataCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.subscribeMessagesCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.recievedChannelId, channelId)
    }
    
    func testSubscribeMessagesWithExistingMessagesSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                 userDataProvider: userDataProviderMock,
                                                 coreDataManager: coreDataManagerMock)
        let channelId = "1"
        conversationNetworkManagerMock.messages = [.init(identifier: "22",
                                                         content: "contenr",
                                                         created: Date(),
                                                         senderId: "Id",
                                                         senderName: "Name"),
                                                   .init(identifier: "23",
                                                         content: "contenr",
                                                         created: Date(),
                                                         senderId: "Id",
                                                         senderName: "Name")]
        let expectation = self.expectation(description: "Subscribing messages")
        var recievedError: Error?
        
        // Act
        dataProvider.subscribeMessages(forChannelWithId: channelId) { error in
            recievedError = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertNil(recievedError)
        XCTAssertEqual(userDataProviderMock.getUserIdCount, 1)
        XCTAssertEqual(userDataProviderMock.loadUserDataCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.subscribeMessagesCount, 1)
        XCTAssertEqual(coreDataManagerMock.performSaveCount, 1)
        XCTAssertEqual(coreDataManagerMock.deleteRangeCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.recievedChannelId, channelId)
        XCTAssertEqual(coreDataManagerMock.recievedEntityName, "Message_db")
        let predicate = NSPredicate(format: "channel.identifier == %@ AND NOT identifier IN %@",
                                    channelId,
                                    ["22", "23"])
        XCTAssertEqual(coreDataManagerMock.recievedPredicate, predicate)
    }
    
    func testUnsibscribeMessagesSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        
        // Act
        dataProvider.unsubscribeChannel()
        
        // Assert
        XCTAssertEqual(conversationNetworkManagerMock.unsubscribeChannelCount, 1)
    }
    
    func testCreateChannelSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        let sentChannelName = "Name"
        var recievedChannelName: String?
        let expectation = self.expectation(description: "Creating channel")
        
        // Act
        dataProvider.createChannel(withName: sentChannelName) { channelName in
            recievedChannelName = channelName
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertEqual(conversationNetworkManagerMock.createChannelCount, 1)
        XCTAssertEqual(sentChannelName, recievedChannelName)
        XCTAssertEqual(conversationNetworkManagerMock.recievedChannelName, sentChannelName)
    }
    
    func testDeleteChannelSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        conversationNetworkManagerMock.channelDeleted = true
        let channelId = "1"
        
        // Act
        dataProvider.deleteChannel(withId: channelId)
        
        // Assert
        XCTAssertEqual(conversationNetworkManagerMock.deleteChannelCount, 1)
        XCTAssertEqual(coreDataManagerMock.performSaveCount, 1)
        XCTAssertEqual(coreDataManagerMock.fetchEntitiesCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.recievedChannelId, channelId)
        XCTAssertEqual(coreDataManagerMock.recievedEntityName, "Channel_db")
        XCTAssertEqual(coreDataManagerMock.recievedPredicate, NSPredicate(format: "identifier == %@", channelId))
    }
    
    func testDeleteChannelUnsuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        conversationNetworkManagerMock.channelDeleted = false
        let channelId = "1"
        
        // Act
        dataProvider.deleteChannel(withId: channelId)
        
        // Assert
        XCTAssertEqual(conversationNetworkManagerMock.deleteChannelCount, 1)
        XCTAssertEqual(coreDataManagerMock.performSaveCount, 1)
        XCTAssertEqual(coreDataManagerMock.fetchEntitiesCount, 0)
        XCTAssertEqual(conversationNetworkManagerMock.recievedChannelId, channelId)
    }
    
    func testDontSendMessageWithoutUserData() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        
        // Act
        dataProvider.sendMessage(widthContent: "") {}
        
        // Assert
        XCTAssertEqual(conversationNetworkManagerMock.sendMessageCount, 0)
    }
    
    func testSendMesageSuccessfully() throws {
        // Arrange
        let conversationNetworkManagerMock = ConversationNetworkManagerMock()
        let userDataProviderMock = UserDataProviderMock()
        let coreDataManagerMock = CoreDataManagerMock()
        let dataProvider = FirestoreDataProvider(networkManager: conversationNetworkManagerMock,
                                                userDataProvider: userDataProviderMock,
                                                coreDataManager: coreDataManagerMock)
        let content = "Content"
        let userName = "Nikita"
        let userId = "Id"
        userDataProviderMock.userId = userId
        userDataProviderMock.userModel = .init(fullName: userName, description: nil, profileImage: nil)
        let expectation = self.expectation(description: "Sending Message")
        
        // Act
        dataProvider.subscribeMessages(forChannelWithId: "1") { _ in
            dataProvider.sendMessage(widthContent: content) {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertEqual(conversationNetworkManagerMock.sendMessageCount, 1)
        XCTAssertEqual(conversationNetworkManagerMock.recievedMessageContent, content)
        XCTAssertEqual(conversationNetworkManagerMock.recievedSenderId, userId)
        XCTAssertEqual(conversationNetworkManagerMock.recievedSenderName, userName)
    }
}
