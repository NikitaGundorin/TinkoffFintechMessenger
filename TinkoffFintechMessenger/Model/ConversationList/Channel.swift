//
//  Channel.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 17.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
