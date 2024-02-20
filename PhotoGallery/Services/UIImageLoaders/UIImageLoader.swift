//
//  UIImageLoader.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 13.02.24.
//

import UIKit

extension UIImage {
    
    class UIImageLoader {
        
        static let standard = UIImageLoader()
        
        private let cache = UIImageCacheLoader.standard
        private let requestService = RequestSessionService()
        
        
        private init() {}
        
        
        private func _loadAndSaveImage(with url: String, by id: String) async -> UIImage? {
            
            var result: UIImage? = nil
            if let data = try? await requestService.performRequest(with: url), let image = UIImage(data: data) {
                result = image
                cache.saveImage(image, key: id)
            }
            return result
            
        }
        
    }
    
}

extension UIImage.UIImageLoader {
    
    func loadImage(with url: String, by id: String) async -> UIImage? {
        
        var image: UIImage? = nil
        if let cachedImage = cache.existingImage(by: id) {
            image = cachedImage
        } else {
           image = await _loadAndSaveImage(with: url, by: id)
        }
        
        return image
        
    }
    
}
