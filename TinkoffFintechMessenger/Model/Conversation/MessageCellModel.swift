//
//  MessageCellModel.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct MessageCellModel {
    let content: String
    let senderId: String
    let senderName: String
    var isIncoming: Bool {
        senderId != userId
    }
    let userId: String
    
    init(content: String, senderId: String, senderName: String, userId: String) {
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.userId = userId
    }
    
    init?(message: Message_db?, userId: String) {
        guard let content = message?.content,
            let senderId = message?.senderId,
            let senderName = message?.senderName else { return nil }
        
        self.init(content: content, senderId: senderId, senderName: senderName, userId: userId)
    }
}
