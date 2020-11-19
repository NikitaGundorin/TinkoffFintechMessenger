//
//  RequestFabric.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 19.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class RequestFabric {
    private static let baseUrl = "https://pixabay.com/api/"
    private static var apiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "PixabayAPIKey") as? String
    }
    
    static func getImagesRequest(forQuery query: String) -> Request<BaseCodableParser<PixabayResponse>> {
        let queryItems: [URLQueryItem] = [.init(name: "key", value: apiKey),
                                          .init(name: "q", value: query),
                                          .init(name: "per_page", value: "200")]
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = queryItems
        return .init(httpMethod: .get, url: urlComponents?.url, parser: .init())
    }
    
    static func getImageDataRequest(forUrl url: URL) -> Request<DataParser> {
        return Request(httpMethod: .get, url: url, parser: DataParser())
    }
}
