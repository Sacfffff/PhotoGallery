//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 9.02.24.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    private let viewModel = ViewModel(service: FetchPhotosService(requestService: RequestSessionService()))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel.loadPhotos()
        
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

