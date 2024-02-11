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
            case error
            
        }
        
        
        @Published private(set) var photos: [Photo] = []
        @Published private(set) var state: State = .loading
        
        private let interactor: Interactor
        
        
        init(service: FetchPhotosServiceProtocol) {
            
            self.interactor = Interactor(service: service)
            
        }
        
        
        func loadPhotos() {
            
            Task {
                let photos = try? await interactor.performFetchPhotos()
                await MainActor.run {
                    self.photos = photos ?? []
                }
                
            }
            
        }
        
    }
    
}

private extension PhotoGalleryViewController.ViewModel {
    
    func photosDidLoad() {
        
        
        
    }
    
    
}
