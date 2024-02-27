//
//  FavoritesViewController+ViewModel.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 27.02.24.
//

import Foundation
import Combine

extension FavoritesViewController {
    
    class ViewModel {
        
        @Published private(set) var photos: [Photo] = []
        
        private let storage = LocalFavoriteModelsManager.shared
        private var cancelBag: Set<AnyCancellable> = []
        
        
        init() {
            setup()
        }
        
        
        private func setup() {
            
            storage.$favorites
                .receive(on: DispatchQueue.main)
                .sink { [weak self] favorites in
                    self?.photos = favorites
                }
                .store(in: &cancelBag)
            
        }
        
    }
    
}

extension FavoritesViewController.ViewModel {
    
    func update(with model: Photo) {
        
        storage.update(with: model)
        
    }
    
}
