//
//  PhotoGalleryViewController+PreviewImageCell.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 13.02.24.
//

import UIKit

extension PhotoGalleryViewController {
    
    class PreviewImageCell: UICollectionViewCell {
        
        private let loader = UIActivityIndicatorView(style: .medium)
        private let imageView: UIImageView = UIImageView()
        private let heartButton: UIButton = UIButton()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
            
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            loader.center = contentView.center
            imageView.frame = contentView.bounds
            
        }
        
        
        func update(with model: Photo) {
            
            if let url = model.urls.regular {
                Task {
                    let image = await UIImage.loader.loadImage(with: url, by: model.id)
                    await MainActor.run {
                        loader.stopAnimating()
                        imageView.image = image
                    }
                }
            }
    
        }
        
        
        private func setup() {
            
            contentView.backgroundColor = .theme.background
            
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            
            loader.hidesWhenStopped = true
            loader.startAnimating()
            contentView.addSubview(loader)
            
        }
        
        
        override func prepareForReuse() {
            
            imageView.image = nil
            
        }
        
    }
    
}
