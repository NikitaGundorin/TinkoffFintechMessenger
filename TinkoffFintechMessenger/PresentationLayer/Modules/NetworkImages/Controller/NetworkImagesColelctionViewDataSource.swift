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
    
    private let cellId: String
    
    // MARK: - Initializer
    
    init(cellId: String) {
        self.cellId = cellId
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        120
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? NetworkImageCell else { return UICollectionViewCell() }
        cell.configure(with: .init(image: nil))
        return cell
    }
}
