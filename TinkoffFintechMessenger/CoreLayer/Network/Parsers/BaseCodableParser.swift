//
//  BaseCodableParser.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 19.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class BaseCodableParser<Model>: IParser where Model: Decodable {
    func parse(data: Data) -> Model? {
        return try? JSONDecoder().decode(Model.self, from: data)
    }
}
