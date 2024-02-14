//
//  UIImageCacheLoader.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 13.02.24.
//

import UIKit

extension UIImage {
 
    class UIImageCacheLoader {
        
        static let standard: UIImageCacheLoader = UIImageCacheLoader()
        
        private var imageCache: NSCache<NSString, UIImage> = {
            let cache = NSCache<NSString, UIImage>()
            cache.countLimit = 100
            cache.totalCostLimit = 1024 * 1024 * 100
            return cache
        }()
        
        
        private init() {}
        
    }

}

extension UIImage.UIImageCacheLoader {
    
    func existingImage(by key: String) -> UIImage? {
        
        return imageCache.object(forKey: key.asNSString)
        
    }
    
    
    func saveImage(_ image: UIImage, key: String) {
        
        self.imageCache.setObject(image, forKey: key.asNSString)
        
    }
    
}

fileprivate extension String{
    
    var asNSString: NSString {
        
        return self as NSString
    }
    
}
