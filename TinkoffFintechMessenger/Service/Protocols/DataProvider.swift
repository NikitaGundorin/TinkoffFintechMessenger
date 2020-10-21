//
//  DataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol DataProvider {
    func subscribeChannels(completion: @escaping ([Channel]?, Error?) -> Void)
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping ([MessageCellModel]?, Error?) -> Void)
    func unsubscribeChannel()
    func createChannel(withName name: String, completion: @escaping (String) -> Void)
    func sendMessage(widthContent content: String, completion: @escaping () -> Void)
}
