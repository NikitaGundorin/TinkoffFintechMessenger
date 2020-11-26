//
//  NetworkImagesColelctionViewDataSource.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class NetworkImagesColelctionViewDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Private properties
    
    private let imagesService: IImagesService?
    private let cellId: String
    private var imageCellModels: [NetworkImageCellModel] = []
    private let loadImageBlock: (NetworkImageCellModel, Int) -> Void
    
    // MARK: - Initializer
    
    init(cellId: String,
         imagesService: IImagesService?,
         loadImageBlock: @escaping (NetworkImageCellModel, Int) -> Void) {
        self.cellId = cellId
        self.imagesService = imagesService
        self.loadImageBlock = loadImageBlock
        super.init()
    }
    
    // MARK: - Public methods
    
    func setImageCellModels(models: [NetworkImageCellModel]) {
        imageCellModels = models
    }
    
    func updateImageCellModel(model: NetworkImageCellModel, number: Int) {
        imageCellModels[number] = model
    }
    
    func getFullUrl(number: Int) -> URL? {
        return imageCellModels[number].fullUrl
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageCellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? NetworkImageCell else { return UICollectionViewCell() }
        let model = imageCellModels[indexPath.item]
        cell.configure(with: model)
        if model.previewUrl != nil {
            loadImageBlock(model, indexPath.item)
            imageCellModels[indexPath.item].previewUrl = nil
        }
        
        return cell
    }
}
