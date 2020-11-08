//
//  INetworkManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 17.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Firebase

protocol INetworkManager {
    func getChannels(completion: @escaping ([Channel]?, Error?) -> Void)
    func subscribeChannels(completion: @escaping ([DocumentChange]?, Error?) -> Void)
    func getMessages(forChannelWithId channelId: String,
                     completion: @escaping ([Message]?, Error?) -> Void)
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping ([DocumentChange]?, Error?) -> Void)
    func unsubscribeChannel()
    func createChannel(withName name: String, completion: @escaping (String) -> Void)
    func deleteChannel(withId identifier: String, completion: @escaping (Bool) -> Void)
    func sendMessage(widthContent content: String,
                     senderId: String,
                     senderName: String,
                     completion: @escaping () -> Void)
}
