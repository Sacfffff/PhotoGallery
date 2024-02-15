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
        private let heartView: HeartView = HeartView()
        
        
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
            
            let size: CGFloat = 0.2 * bounds.height
            let x: CGFloat = contentView.bounds.width - size - 5.0
            let y: CGFloat = 5.0
            heartView.frame = CGRect(x: x, y: y, width: size, height: size)
            heartView.layer.cornerRadius = size / 2
            
        }
        
        
        func update(with model: Photo) {
            
            heartView.isHidden = true
            heartView.update(with: model)
            
            if let url = model.urls.regular {
                Task {
                    if let image = await UIImage.loader.loadImage(with: url, by: model.id) {
                        await MainActor.run {
                            loader.stopAnimating()
                            heartView.isHidden = false
                            imageView.image = image
                        }
                    } else {
                        loader.stopAnimating()
                        imageView.contentMode = .scaleAspectFit
                        imageView.image = UIImage.noImage
                    }
                }
            }
    
        }
        
        
        private func setup() {
            
            contentView.backgroundColor = .theme.background
            
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            
            heartView.clipsToBounds = true
            contentView.addSubview(heartView)
            
            loader.hidesWhenStopped = true
            loader.startAnimating()
            contentView.addSubview(loader)
            
        }
        
        
        override func prepareForReuse() {
            
            imageView.image = nil
            
        }
        
    }
    
}

extension PhotoGalleryViewController.PreviewImageCell {
    
    class HeartView: UIView {
        
        private let blurView : UIVisualEffectView = UIVisualEffectView()
        private let heartImageView: UIImageView = UIImageView()
        private let actionButton: UIButton = UIButton()
        
        private var isSelected: Bool = false {
            
            didSet {
                updateHeartImage(isSelected: isSelected)
            }
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
            
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let size: CGFloat = bounds.width / 2
            let x: CGFloat = bounds.width / 2 - size / 2
            let y: CGFloat = bounds.height / 2 - size / 2
            heartImageView.frame = CGRect(origin: .init(x: x, y: y), size: .init(width: size, height: size))
            
            blurView.frame = bounds
            
            actionButton.frame = bounds
            
        }
        
        
        func update(with model: Photo) {
            
            isSelected = model.isFavorite ?? false
    
        }
        
        
        private func setup() {
            
            blurView.effect = UIBlurEffect(style: .dark)
            blurView.alpha = 0.5
            addSubview(blurView)
            
            heartImageView.contentMode = .scaleAspectFit
            addSubview(heartImageView)
            
            actionButton.addAction(.init(handler: { [weak self] _ in
                if let self {
                    self.isSelected = !self.isSelected
                }
            }), for: .touchUpInside)
            addSubview(actionButton)
            
        }
        
        
        private func updateHeartImage(isSelected: Bool) {
            
            heartImageView.image = isSelected ? UIImage.selectedHeart : UIImage.heart
            
        }
        
    }
    
}
