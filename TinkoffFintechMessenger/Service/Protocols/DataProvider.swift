//
//  DataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol DataProvider {
    var userId: String? { get }
    
    func subscribeChannels(completion: @escaping (Error?) -> Void)
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping (Error?) -> Void)
    func unsubscribeChannel()
    func createChannel(withName name: String, completion: @escaping (String) -> Void)
    func deleteChannel(withId identifier: String)
    func sendMessage(widthContent content: String, completion: @escaping () -> Void)
}
