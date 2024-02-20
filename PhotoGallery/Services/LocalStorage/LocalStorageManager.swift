//
//  LocalStorageManager.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 19.02.24.
//

import Foundation
    
class LocalStorageManager {
    
    static let standard: LocalStorageManager = LocalStorageManager()
    private let folderName: String = "PhotoApp_LocalData"
    
    private init() {}
    
    
    private func filePath(for name: String) -> URL? {
        
        createFolderIfNeeded()
        
        guard let urlForFolder else { return nil }
        
        return urlForFolder.appendingPathComponent(name)
        
    }
    
    
    private func createFolderIfNeeded() {
        
        guard let urlForFolder else { return }
        
        if !FileManager.default.fileExists(atPath: urlForFolder.path()) {
            try? FileManager.default.createDirectory(at: urlForFolder, withIntermediateDirectories: true)
        }
        
    }
    
    
    private var urlForFolder: URL? {
        
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(folderName, conformingTo: .folder)
        
    }
    
}


extension LocalStorageManager {
    
    func read<T: Codable>(from type: FileName) -> T? {

        if let filePath = filePath(for: type.fileName), let data = try? Data(contentsOf: filePath) {
            return try? JSONDecoder().decode(T.self, from: data)
        }

        return nil
        
    }
    
    
    func write<T: Codable>(data: T, to type: FileName) {
        
        if let filePath = filePath(for: type.fileName) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            try? encoder.encode(data).write(to: filePath)
        }
        
    }
    
}

extension LocalStorageManager {
    
    enum FileName {
        
        case favorites
        case custom(fileName: String)
        
        var fileName: String {
            
            return switch self {
                case .custom(fileName: let name):
                    name
                default:
                    "\(self)"
            }
            
        }
        
    }
    
}
