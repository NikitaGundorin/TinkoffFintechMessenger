//
//  NetworkImageCell.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 18.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class NetworkImageCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: placeholderImage)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let placeholderImage = UIImage(named: "ImagePlaceholder")
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setPlaceholderImage()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setPlaceholderImage() {
        imageView.image = placeholderImage
    }
}

// MARK: - IConfigurableView

extension NetworkImageCell: IConfigurableView {
    
    func configure(with model: NetworkImageCellModel) {
        if let image = model.image {
            imageView.image = image
        } else {
            setPlaceholderImage()
        }
    }
}
