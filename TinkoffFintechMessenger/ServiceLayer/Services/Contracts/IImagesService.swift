//
//  IImagesService.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 19.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol IImagesService {
    func getImagesUrls(completion: @escaping (Result<[ImageModel], PixabayServiceError>) -> Void)
    func getImageData(byUrl url: URL, completion: @escaping (Result<Data, PixabayServiceError>) -> Void)
}
