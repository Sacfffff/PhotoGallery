//
//  PhotoGalleryDetailViewController+ViewModel.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 21.02.24.
//

import UIKit

extension PhotoGalleryDetailViewController {
    
    class ViewModel {
        
        var currentModel: Photo {
            
            return models[currentIndex]
        }
        
        private(set) var models: [Photo]
        private(set) var currentIndex: Int
        
        
        init(models: [Photo], selectedModelIndex: Int) {
           
            self.models = models
            self.currentIndex = selectedModelIndex
            
        }
        
        
        func updateCurrentIndex(_ newIndex: Int) {
            
            currentIndex = newIndex
            
        }
        
        
        func updateCurrentModel(with isSelected: Bool) {
            
            models[currentIndex].updateIsFavorite(newValue: isSelected)
            
        }
        
    }
    
}
