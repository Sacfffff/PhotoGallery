//
//  Photo.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 10.02.24.
//

import Foundation

struct Photo: Codable {
    
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let urls: Urls
    
    var isFavorite: Bool? = false
    
}

extension Photo {
    
    struct Urls: Codable {
        
        let raw: String?
        let full: String?
        let regular: String?
        let small: String?
        let thumb: String?
        let smallS3: String?
        
        enum CodingKeys: String, CodingKey {
            
            case raw
            case full
            case regular
            case small
            case thumb
            case smallS3 = "small_s3"
            
        }
        
    }
    
}

extension Photo: Equatable, Hashable {
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        
        return lhs.id == rhs.id
        
    }
    
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
        
    }
    
}
