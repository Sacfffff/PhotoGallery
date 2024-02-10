//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 9.02.24.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    private let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
    }
    
    
    private func setup() {
        
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("gallery.navigation.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }


}

