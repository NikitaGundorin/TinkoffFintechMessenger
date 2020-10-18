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
}
