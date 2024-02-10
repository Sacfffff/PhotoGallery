//
//  NetworkManager.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 10.02.24.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    
    func performRequest(with path: String) async throws -> Data

}

class NetworkManager: NetworkManagerProtocol {
    
    func performRequest(with path: String) async throws -> Data {
        
        if let url = URL(string: path) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                return data
            } catch {
                throw error
            }
        } else {
            throw URLError(.badURL)
        }
        
    }
    
}
