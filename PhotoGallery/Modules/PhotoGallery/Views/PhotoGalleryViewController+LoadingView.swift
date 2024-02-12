//
//  PhotoGalleryViewController+LoadingView.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 12.02.24.
//

import UIKit

extension PhotoGalleryViewController {
    
    class LoadingView: UIView {
        
        private let view = UIActivityIndicatorView(style: .large)
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
            
        }
        
        
        required init?(coder: NSCoder) {
            super.init(frame: .zero)
        }
        
        
        private func setup() {
            
            addSubview(view)
            view.startAnimating()
            
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            view.frame = bounds
            
        }
        
    }
    
}
