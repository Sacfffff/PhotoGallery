//
//  NetworkManager.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 10.02.24.
//

import Foundation

protocol RequestSessionServiceProtocol: AnyObject {
    
    func performRequest(with path: String) async throws -> Data

}

class RequestSessionService: RequestSessionServiceProtocol {
    
    func performRequest(with path: String) async throws -> Data {
        
        if let url = URL(string: path) {
            try await URLSession.shared.data(from: url).0
        } else {
            throw URLError(.badURL)
        }
        
    }
    
}
