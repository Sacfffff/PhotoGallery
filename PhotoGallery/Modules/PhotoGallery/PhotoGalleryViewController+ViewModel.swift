//
//  PhotoGalleryViewController+ViewModel.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 11.02.24.
//

import Foundation
import Combine

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
        
        private(set) var hasMorePhotos: Bool = true
        
        private let favoritesStorage = LocalFavoriteModelsManager.shared
        
        private var isLoading: Bool = false
        private let interactor: Interactor
        
        private var timer: Timer? = nil
        private var cancelBag: Set<AnyCancellable> = []
        
        
        init(service: FetchPhotosServiceProtocol) {
            
            self.interactor = Interactor(service: service)
            setup()
            
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
                    self?.photos[index].updateIsFavorite(newValue: isFavorite)
                    self?.updateFavorites(model: self?.photos[index])
                    self?.updateOperationHandler?(.reloadItem(index: index))
                })
            }
            
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
    
    func setup() {
        
        favoritesStorage.$removedModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                if let model {
                    self?.updateLocalPhotos(model: model)
                }
            }
            .store(in: &cancelBag)
        
    }
    
    
    func updateLocalPhotos(model: Photo) {
        
        if let index = photos.firstIndex(where: { $0.id == model.id }), photos[index].isFavorite != model.isFavorite {
            photos[index].updateIsFavorite(newValue: model.isFavorite)
            updateOperationHandler?(.reloadItem(index: index))
        }
        
    }
    
    
    func modelsDidLoad(newModels: [Photo]? = nil, error: Error? = nil) {
        
        if photos.isEmpty {
            if let error {
                state = .error(error)
            }
        }
        
        if let newModels {
            state = .loaded
            let replacedModels = newModels.findAndReplaceModel(withContentsOf: favoritesStorage.favorites)
            photos.merge(contentsOf: replacedModels)
            updateOperationHandler?(.reloadData)
        }
        
        isLoading = false
        
    }
    
    
    private func updateFavorites(model: Photo?) {
        
        if let model {
            favoritesStorage.update(with: model)
        }
        
    }
    
}

fileprivate extension Array where Element == Photo {
    
    mutating func merge(contentsOf newModels: [Photo]) {
        
        self.append(contentsOf: newModels.reduce(into: [], { partialResult, photo in
            if !self.contains(where: { $0.id == photo.id }) {
                partialResult.append(photo)
            }
        }))
        
    }
    
    
    func findAndReplaceModel(withContentsOf existingModels: [Photo]) -> [Photo] {
        
        return self.reduce(into: []) { partialResult, model in
            if let existingModel = existingModels.first(where: { $0.id == model.id }), model.isFavorite != existingModel.isFavorite {
                var copy = model
                copy.updateIsFavorite(newValue: existingModel.isFavorite)
                partialResult.append(copy)
            } else {
                partialResult.append(model)
            }
        }
        
    }
    
}
