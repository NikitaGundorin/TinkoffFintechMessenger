//
//  Request.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 19.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct Request<Parser>: IRequest where Parser: IParser {
    let httpMethod: HTTPMethod
    let url: URL?
    let parser: Parser
    let data: Data?
    let contentType: String?
    
    init(httpMethod: HTTPMethod,
         url: URL?,
         parser: Parser,
         data: Data? = nil,
         contentType: String? = nil) {
        self.httpMethod = httpMethod
        self.url = url
        self.parser = parser
        self.data = data
        self.contentType = contentType
    }
}
