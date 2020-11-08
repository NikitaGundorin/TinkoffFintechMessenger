//
//  Channel.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 17.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    init?(channel: Channel_db?) {
        guard let identifier = channel?.identifier, let name = channel?.name else { return nil }
        self.init(identifier: identifier, name: name, lastMessage: channel?.lastMessage, lastActivity: channel?.lastActivity)
    }
    
    init?(document: QueryDocumentSnapshot) {
        let lastMessage = document["lastMessage"] as? String
        let lastActivity = (document["lastActivity"] as? Timestamp)?.dateValue()
        guard let name = document["name"] as? String,
            !name.isEmptyOrOnlyWhitespaces,
            (lastMessage != nil && lastActivity != nil)
                || (lastActivity == nil && lastMessage == nil)
            
            else { return nil }
        
        self.init(identifier: document.documentID,
                  name: name,
                  lastMessage: lastMessage,
                  lastActivity: lastActivity)
    }
}
