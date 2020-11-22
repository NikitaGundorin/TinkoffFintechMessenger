//
//  Message.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 15.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Firebase

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init(identifier: String, content: String, created: Date, senderId: String, senderName: String) {
        self.identifier = identifier
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init?(document: QueryDocumentSnapshot) {
        guard let content = document["content"] as? String,
            !content.isEmptyOrOnlyWhitespaces,
            let created = (document["created"] as? Timestamp)?.dateValue(),
            let senderId = document["senderId"] as? String,
            !senderId.isEmptyOrOnlyWhitespaces,
            let senderName = document["senderName"] as? String,
            !senderName.isEmptyOrOnlyWhitespaces
        else { return nil }
        
        self.init(identifier: document.documentID,
                  content: content,
                  created: created,
                  senderId: senderId,
                  senderName: senderName)
    }
}
