//
//  PixabayResponse.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 19.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct PixabayResponse: Decodable {
    let hits: [PixabayImage]
}
