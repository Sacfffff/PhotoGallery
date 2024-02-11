//
//  FetchImagesManager.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 10.02.24.
//

import UIKit

protocol FetchPhotosServiceProtocol {
    
    func fetchListPhotos(with requestParams: RequestParameters) async throws -> [Photo]
    func fetchPhoto(with url: String) async throws -> UIImage?
    
}

class FetchPhotosService: FetchPhotosServiceProtocol {
    
    private enum Constants {
        
        static let baseAPIUrl = "https://api.unsplash.com/photos/"
        static let clientId = "exRJ3IqzNVyYbLjqjlRC8EyR7gWbhxAdadp3W17hzg8"
    }
    
    
    private let requestService: RequestSessionServiceProtocol
    
    
    init(requestService: RequestSessionServiceProtocol) {
        
        self.requestService = requestService
        
    }
    
    
    func fetchListPhotos(with requestParams: RequestParameters) async throws -> [Photo] {
        
        let path = "\(Constants.baseAPIUrl)?client_id=\(Constants.clientId)&page=\(requestParams.page)&per_page=\(requestParams.photosPerPage)"
        
        do {
            let data = try await requestService.performRequest(with: path)
            return try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            throw error
        }
        
    }
    
    
    func fetchPhoto(with url: String) async throws -> UIImage? {
        
        do {
            let data = try await requestService.performRequest(with: url)
            return UIImage(data: data)
        } catch {
            throw error
        }
        
    }
    
}
