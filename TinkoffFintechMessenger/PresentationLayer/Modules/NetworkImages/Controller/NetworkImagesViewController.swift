//
//  NetworkImagesViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class NetworkImagesViewController: UIViewController {
    
    // MARK: - Public properties
    
    var imagesService: IImagesService?
    var imageSelectedBlock: ((UIImage) -> Void)?
    
    // MARK: - UI
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = Appearance.selectionColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    private lazy var collectionViewDelegate = NetworkImagesCollectionViewDelegate(cellDidSelectBlock: { [weak self] number in
        self?.didSelectImage(number: number)
    })
    private lazy var collectionViewDataSource =
        NetworkImagesColelctionViewDataSource(cellId: cellId,
                                              imagesService: imagesService) { [weak self] (model, number) in
                                                self?.loadImageData(model: model,
                                                                    number: number)
                                                
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupLayout()
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        view.backgroundColor = Appearance.backgroundColor
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        activityIndicatorView.startAnimating()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancel))
        navigationItem.title = "Network Images"
    }
    
    private func loadData() {
        imagesService?.getImagesUrls(completion: { [weak self] result in
            switch result {
            case .failure:
                print("ERROR")
            case .success(let imageModels):
                let models = imageModels.map { NetworkImageCellModel(image: nil,
                                                                     previewUrl: $0.previewURL,
                                                                     fullUrl: $0.fullUrl) }
                DispatchQueue.main.async {
                    self?.collectionViewDataSource.setImageCellModels(models: models)
                    self?.collectionView.reloadData()
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        })
    }
    
    private func loadImageData(model: NetworkImageCellModel, number: Int) {
        guard let url = model.previewUrl else { return }
        imagesService?.getImageData(byUrl: url, completion: { result in
            switch result {
            case .failure:
                print("error")
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.collectionViewDataSource.updateImageCellModel(model: .init(image: UIImage(data: data),
                                                                                     previewUrl: nil,
                                                                                     fullUrl: model.fullUrl),
                                                                        number: number)
                    self?.collectionView.reloadData()
                }
            }
        })
    }
    
    private func didSelectImage(number: Int) {
        activityIndicatorView.startAnimating()
        guard let url = collectionViewDataSource.getFullUrl(number: number) else {
            presentErrorAlert()
            activityIndicatorView.stopAnimating()
            return
        }
        
        imagesService?.getImageData(byUrl: url, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    self?.presentErrorAlert()
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        self?.presentErrorAlert()
                        return
                    }
                    self?.imageSelectedBlock?(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    private func presentErrorAlert() {
        AlertHelper().presentErrorAlert(vc: self, message: "Failed to load image")
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
