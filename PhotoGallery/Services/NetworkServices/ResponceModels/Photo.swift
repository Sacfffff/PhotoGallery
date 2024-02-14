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
