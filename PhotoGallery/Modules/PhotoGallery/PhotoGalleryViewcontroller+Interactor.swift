//
//  PhotoGalleryViewcontroller+Interactor.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 11.02.24.
//

import Foundation

extension PhotoGalleryViewController {
    
    class Interactor {
        
        private var page: Int = 1
        private let photosPerPage: Int = 30
        
        private let service: FetchPhotosServiceProtocol
        
        
        init(service: FetchPhotosServiceProtocol) {
            
            self.service = service
            
        }
        
        
        func performFetchPhotos() async throws -> [Photo] {
            
            let photos = try await service.fetchListPhotos(with: requestParams)
            page += 1
            return photos
            
        }
        
    }
    
}

private extension PhotoGalleryViewController.Interactor {
    
    var requestParams: RequestParameters {
        
        return .init(page: page, photosPerPage: photosPerPage)
    }
    
}
