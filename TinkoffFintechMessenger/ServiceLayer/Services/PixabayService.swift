//
//  PixabayService.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 19.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class PixabayService: IImagesService {
    
    // MARK: - Private properties
    
    private let networkManager: INetworkManager
    
    // MARK: - Initializer
    
    init(networkManager: INetworkManager) {
        self.networkManager = networkManager
    }
    
    func getImagesUrls(completion: @escaping (Result<[ImageModel], PixabayServiceError>) -> Void) {
        let request = RequestFactory.getImagesRequest(forQuery: "animals")
        networkManager.makeRequest(request,
                                   session: URLSession.shared) { result in
                                    switch result {
                                    case .failure:
                                        completion(.failure(.error))
                                        
                                    case .success(let model):
                                        let imageModels = model.hits.map { ImageModel(previewURL: $0.previewURL,
                                                                                      fullUrl: $0.webformatURL) }
                                        completion(.success(imageModels))
                                    }
        }
    }
    
    func getImageData(byUrl url: URL, completion: @escaping (Result<Data, PixabayServiceError>) -> Void) {
        let request = RequestFactory.getImageDataRequest(forUrl: url)
        networkManager.makeRequest(request,
                                   session: URLSession.shared) { result in
                                    switch result {
                                    case .failure:
                                        completion(.failure(.error))
                                    case .success(let data):
                                        completion(.success(data))
                                    }
        }
    }
}

enum PixabayServiceError: Error {
    case error
}
