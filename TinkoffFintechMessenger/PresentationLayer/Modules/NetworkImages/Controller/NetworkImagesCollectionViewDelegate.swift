//
//  NetworkImagesCollectionViewDelegate.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class NetworkImagesCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    // MARK: - Private properties
    
    private let cellDidSelectBlock: (Int) -> Void
    
    // MARK: - Initializer
    
    init(cellDidSelectBlock: @escaping (Int) -> Void) {
        self.cellDidSelectBlock = cellDidSelectBlock
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDidSelectBlock(indexPath.item)
    }
}
