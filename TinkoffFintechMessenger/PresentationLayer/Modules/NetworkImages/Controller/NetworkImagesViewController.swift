//
//  NetworkImagesViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class NetworkImagesViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        let cellSize: CGFloat = view.bounds.width / 3 - padding * 1.5
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NetworkImageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDataSource
        collectionView.backgroundColor = Appearance.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let padding: CGFloat = 10
    
    // MARK: - Private properties
    
    private let cellId = "imageCell"
    private let collectionViewDelegate = NetworkImagesCollectionViewDelegate()
    private lazy var collectionViewDataSource = NetworkImagesColelctionViewDataSource(cellId: cellId)
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                 target: self,
                                                 action: #selector(cancel))
        navigationItem.title = "Network Images"
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
