//
//  PhotoGalleryViewController+ViewModel.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 11.02.24.
//

import Foundation

extension PhotoGalleryViewController {
    
    @MainActor
    class ViewModel {
        
        enum State {
            
            case loading
            case loaded
            case error
            
        }
        
        
        @Published private(set) var photos: [Photo] = []
        @Published private(set) var state: State = .loading
        
        private var isLoading: Bool = false
        private let interactor: Interactor
        
        
        init(service: FetchPhotosServiceProtocol) {
            
            self.interactor = Interactor(service: service)
            
        }
        
        
        func loadPhotos() {
            
            if !isLoading {
                isLoading = true
                Task {
                    let photos = try? await interactor.performFetchPhotos()
                    self.photos = photos ?? []
                    isLoading = false
                }
            }
            
        }
        
    }
    
}

private extension PhotoGalleryViewController.ViewModel {
    
    func photosDidLoad() {
        
        
        
    }
    
    
}
