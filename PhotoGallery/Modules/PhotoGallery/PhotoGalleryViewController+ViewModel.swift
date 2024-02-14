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
        
        private var isLoading: Bool = false
        private let interactor: Interactor
        
        
        init(service: FetchPhotosServiceProtocol) {
            
            self.interactor = Interactor(service: service)
            
        }
        
        
        func performFetchingPhotos() {
            
            if !isLoading {
                isLoading = true
                Task {
                    let photos = (try? await interactor.performFetchPhotos()) ?? []
                    self.isLoading = false
                    self.state = .loaded
                    self.photos.merge(contentsOf: photos)
                }
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
    
}
