//
//  Message.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 15.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}
