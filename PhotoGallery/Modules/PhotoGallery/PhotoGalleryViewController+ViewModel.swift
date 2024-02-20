//
//  PhotoGalleryViewController+ViewModel.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 11.02.24.
//

import Foundation

extension PhotoGalleryViewController {
    
    class ViewModel {
        
        enum State {
            
            case loading
            case loaded
            case error(Error)
            
        }
        
        var updateOperationHandler: ((UpdateAction)->Void)?
        
        @Published private(set) var photos: [Photo] = []
        @Published private(set) var state: State = .loading
        @Published private(set) var favorites: Set<Photo> = []
        private(set) var hasMorePhotos: Bool = true
        
        private var isLoading: Bool = false
        private let interactor: Interactor
        
        private var timer: Timer? = nil
        
        
        init(service: FetchPhotosServiceProtocol) {
            
            self.interactor = Interactor(service: service)
            self.favorites = LocalStorageManager.standard.read(from: .favorites) ?? []
            
        }
        
        
        func performFetchingPhotos() {
            
            if !isLoading {
                isLoading = true
                Task {
                    do {
                        let photos = try await interactor.performFetchPhotos()
                        modelsDidLoad(newModels: photos)
                    } catch {
                        modelsDidLoad(error: error)
                    }
                }
            }
            
        }
        
        
        func updateExistingModel(isFavorite: Bool, model: Photo) {
            
            timer?.invalidate()
            if let index = photos.firstIndex(where: { $0.id == model.id }), photos[index].isFavorite != isFavorite {
                timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
                    self?.photos[index].isFavorite = isFavorite
                    self?.updateFavorites(model: self?.photos[index])
                })
            }
            
        }
        
        
        func saveLocalData() {
            
            LocalStorageManager.standard.write(data: favorites, to: .favorites)
        
        }
        
    }
    
}


extension PhotoGalleryViewController.ViewModel {
    
    enum UpdateAction {
        
        case reloadItem(index: Int)
        case reloadData
        
    }
    
}

private extension PhotoGalleryViewController.ViewModel {
    
    func modelsDidLoad(newModels: [Photo]? = nil, error: Error? = nil) {
        
        if photos.isEmpty {
            if let error {
                state = .error(error)
            }
        }
        
        if let newModels {
            state = .loaded
            let replacedModels = newModels.findAndReplaceModel(withContentsOf: Array(favorites))
            photos.merge(contentsOf: replacedModels)
            updateOperationHandler?(.reloadData)
        }
        
        isLoading = false
        
    }
    
    
    private func updateFavorites(model: Photo?) {
        
        if let model {
            if favorites.contains(where: { $0.id == model.id }) {
                favorites.remove(model)
            } else {
                favorites.insert(model)
            }
        }
        
    }
    
}

fileprivate extension Array where Element == Photo {
    
    mutating func merge(contentsOf newModels: [Photo]) {
        
        self.append(contentsOf: newModels.reduce(into: [], { partialResult, photo in
            if !self.contains(where: { $0.id == photo.id }) && photo.urls.regular != nil {
                partialResult.append(photo)
            }
        }))
        
    }
    
    
    func findAndReplaceModel(withContentsOf existingModels: [Photo]) -> [Photo] {
        
        var result: [Photo] = self
        for model in existingModels {
            if let modelToReplaceIndex = result.firstIndex(where: { $0.id == model.id }) {
                result[modelToReplaceIndex].isFavorite = model.isFavorite
            } else {
                break
            }
        }
        return result
        
    }
    
}
