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
    let location: Location?
    let user: User?
    
    private(set) var isFavorite: Bool
    
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.urls = try container.decode(Photo.Urls.self, forKey: .urls)
        self.location = try container.decodeIfPresent(Photo.Location.self, forKey: .location)
        self.user = try container.decodeIfPresent(Photo.User.self, forKey: .user)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        
    }
    
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
    
    struct Location: Codable {
        
        let name: String?
        let city: String?
        let country: String?
        
    }
    
    struct User: Codable {
        
        let username: String?
        let name: String?
        
    }
    
}

extension Photo {
    
    mutating func updateIsFavorite(newValue: Bool) {
        
        self.isFavorite = newValue
        
    }
    
}
