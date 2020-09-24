//
//  DummyDataFabric.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class DummyDataFabric {
    static func getUser() -> Person {
        .init(firstName: "Nikita", secondName: "Gundorin", profileImage: nil)
    }
}
