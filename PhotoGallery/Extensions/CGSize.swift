//
//  CGSize.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 21.02.24.
//

import UIKit

extension CGSize {
    
    func sizeInRect(rectSize: CGSize, fit: Bool) -> CGSize {
        
        let widthFactor = width / rectSize.width
        let heightFactor = height / rectSize.height
        
        let maxFactor = max(widthFactor, heightFactor)
        let minFactor = min(widthFactor, heightFactor)
        let resizeFactor = fit ? maxFactor : minFactor
        
        return CGSize(width: width / resizeFactor, height: height / resizeFactor)
        
    }
    
}
