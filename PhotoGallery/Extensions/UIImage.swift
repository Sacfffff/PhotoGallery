//
//  UIImage.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 13.02.24.
//

import UIKit

extension UIImage {
 
    static var loader: UIImageLoader {
        
        return UIImageLoader.standard
    }
    
}

extension UIImage {
    
    func resizedImage(newSize: CGSize) -> UIImage {
        
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
    }
    
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        
        return resizedImage(newSize: size.sizeInRect(rectSize: rectSize, fit: true))
        
    }
    
}
