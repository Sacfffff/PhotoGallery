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
        
        
        @Published private(set) var photos: [Photo] = []
        @Published private(set) var state: State = .loading
        private(set) var hasMorePhotos: Bool = true
        
        private var isLoading: Bool = false
        private let interactor: Interactor
        
        
        init(service: FetchPhotosServiceProtocol) {
            
            self.interactor = Interactor(service: service)
            
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
            self.photos.merge(contentsOf: newModels)
        }
        
        isLoading = false
        
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
    
}
