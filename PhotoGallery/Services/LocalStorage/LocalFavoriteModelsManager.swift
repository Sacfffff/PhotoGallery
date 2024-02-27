//
//  LocalFavoriteModelsManager.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 27.02.24.
//

import Foundation
import UIKit
import Combine

class LocalFavoriteModelsManager {
    
    static let shared = LocalFavoriteModelsManager()
    
    @Published private(set) var favorites: [Photo] = []
    @Published private(set) var removedModel: Photo? = nil
    
    private let storage = LocalStorage()
    private var cancelBag: Set<AnyCancellable> = []
    
    private let lock = NSLock()
    
    private init() {
        setup()
    }
    
    
    private func setup() {
        
        favorites = storage.read(from: .favorites) ?? []
        
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.saveLocalData()
            }
            .store(in: &cancelBag)
        
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { [weak self] _ in
                self?.saveLocalData()
            }
            .store(in: &cancelBag)
        
    }
    
    
   private func saveLocalData() {
        
        storage.write(data: favorites, to: .favorites)
    
    }
    
}

extension LocalFavoriteModelsManager {
    
    func update(with model: Photo) {
        
        lock.lock()
        var model = model
        if favorites.contains(where: { $0.id == model.id }) {
            favorites.removeAll(where: { $0.id == model.id })
            model.updateIsFavorite(newValue: false)
            removedModel = model
        } else {
            favorites.append(model)
        }
        lock.unlock()
        
    }
    
}
