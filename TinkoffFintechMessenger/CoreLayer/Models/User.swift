//
//  User.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct User: Codable {
    var fullName: String
    var description: String?
    var imageUrl: URL?
}
