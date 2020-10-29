//
//  Channel_db+Init.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 28.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import CoreData

extension Channel_db {
    convenience init(channel: Channel, context: NSManagedObjectContext) {
        self.init(context: context)
        
        identifier = channel.identifier
        name = channel.name
        lastMessage = channel.lastMessage
        lastActivity = channel.lastActivity
    }
}
