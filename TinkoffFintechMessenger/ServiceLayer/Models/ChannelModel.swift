//
//  ChannelModel.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 11.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct ChannelModel {
    let identifier: String
    let name: String
    let lastActivity: Date?
    let lastMessage: String?
    
    init?(channel: Channel_db) {
        guard let identifier = channel.identifier,
            let name = channel.name
            else { return nil}
        
        self.identifier = identifier
        self.name = name
        self.lastActivity = channel.lastActivity
        self.lastMessage = channel.lastMessage
    }
}
