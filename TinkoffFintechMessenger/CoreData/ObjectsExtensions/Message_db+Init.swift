//
//  Message_db+Init.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import CoreData

extension Message_db {
    convenience init(message: Message, context: NSManagedObjectContext) {
        self.init(context: context)
        
        identifier = message.identifier
        content = message.content
        created = message.created
        senderId = message.senderId
        senderName = message.senderName
    }
}
