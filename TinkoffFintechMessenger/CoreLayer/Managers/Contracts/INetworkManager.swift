//
//  INetworkManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 19.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol INetworkManager {
    func makeRequest<Request>(_ request: Request,
                              session: URLSession,
                              completion: @escaping (Result<Request.Parser.Model, NetworkError>) -> Void) where Request: IRequest
}
