//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Aleks Kravtsova on 9.02.24.
//

import UIKit
import Combine

class PhotoGalleryViewController: UIViewController {
    
    private let viewModel = ViewModel(service: FetchPhotosService(requestService: RequestSessionService()))
    
    private var infoContainerView: UIView?
    
    private var cancelBag: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel.performFetchingPhotos()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
        
    }
    
    
    private func layout() {
        
        infoContainerView?.frame = view.bounds.inset(by: .init(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0))
        
    }
    
    
    private func setup() {
        
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("gallery.navigation.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateState()
            }
            .store(in: &cancelBag)
        
    }
    
    
    private func updateState() {
        
        infoContainerView?.removeFromSuperview()
        infoContainerView = nil
        
        switch viewModel.state {
            case .loading:
                infoContainerView = LoadingView()
            case .loaded:
                break
            case .error:
                let errorView = ErrorView()
                errorView.actionHandler = {
                    
                }
                infoContainerView = errorView
        }
        
        if let infoContainerView {
            view.addSubview(infoContainerView)
        }
        
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        layout()
        
    }
    
}

