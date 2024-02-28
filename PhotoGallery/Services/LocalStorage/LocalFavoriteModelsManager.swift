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
    
    private let lock = DispatchQueue(label: "PhotoApp_LocalFavoriteModelsManager", attributes: .concurrent)
    
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
        
        lock.async(flags: .barrier) { [weak self] in
            if let self {
                var model = model
                if self.favorites.contains(where: { $0.id == model.id }) {
                    self.favorites.removeAll(where: { $0.id == model.id })
                    model.updateIsFavorite(newValue: false)
                    self.removedModel = model
                } else {
                    self.favorites.append(model)
                }
            }
        }
        
    }
    
}
