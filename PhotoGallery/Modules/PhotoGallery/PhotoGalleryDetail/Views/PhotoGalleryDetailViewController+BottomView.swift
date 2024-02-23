//
//  PhotoGalleryDetailViewController+BottomView.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 22.02.24.
//

import UIKit

extension PhotoGalleryDetailViewController {
    
    class BottomView: UIView {
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
            
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            
        }
        
        
        private func setup() {
            
            backgroundColor = .black.withAlphaComponent(0.4)
            self.layer.cornerRadius = 16
            
        }
        
        
    }
    
}
