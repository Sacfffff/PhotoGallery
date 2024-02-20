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
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: PreviewImageCellLayout())
    
    private var cancelBag: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel.performFetchingPhotos()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
        
    }
    
    
    private func layout() {
        
        infoContainerView?.frame = view.bounds.inset(by: .init(top: view.safeAreaInsets.top, left: 0, bottom: view.safeAreaInsets.bottom, right: 0))
        collectionView.frame = view.bounds
        
    }
    
    
    private func setup() {
        
        view.backgroundColor = .theme.background
        title = NSLocalizedString("gallery.navigation.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        (collectionView.collectionViewLayout as? PreviewImageCellLayout)?.isPortraitOrientation = UIApplication.keyWindowInterfaceOrientation.isPortrait
        collectionView.contentInset = .init(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PreviewImageCell.self, forCellWithReuseIdentifier: "\(PreviewImageCell.self)")
        view.addSubview(collectionView)
    
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateState()
            }
            .store(in: &cancelBag)
        
        viewModel.updateOperationHandler = { [weak self] type in
            DispatchQueue.main.async {
                self?.handleAction(with: type)
            }
        }
        
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.viewModel.saveLocalData()
            }
            .store(in: &cancelBag)
        
    }
    
    
    private func updateState() {
        
        infoContainerView?.removeFromSuperview()
        infoContainerView = nil
        
        collectionView.alpha = 0
        
        switch viewModel.state {
            case .loading:
                infoContainerView = LoadingView()
            case .loaded:
                collectionView.alpha = 1
            case .error:
                let errorView = ErrorView()
                errorView.actionHandler = {
                    
                }
                infoContainerView = errorView
        }
        
        if let infoContainerView {
            view.addSubview(infoContainerView)
            layout()
        }
        
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        (collectionView.collectionViewLayout as? PreviewImageCellLayout)?.isPortraitOrientation = UIApplication.keyWindowInterfaceOrientation.isPortrait
        collectionView.collectionViewLayout.invalidateLayout()
        layout()
        
    }
    
}

private extension PhotoGalleryViewController {
    
    func handleAction(with type: ViewModel.UpdateAction) {
        
        UIView.setAnimationsEnabled(false)
        switch type {
            case .reloadItem(index: let index):
                collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            case .reloadData:
                collectionView.reloadData()
        }
        UIView.setAnimationsEnabled(true)
        
    }
    
}

extension PhotoGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.photos.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PreviewImageCell.self)", for: indexPath) as? PreviewImageCell {
            cell.update(with: viewModel.photos[indexPath.row])
            cell.actionHandler = { [weak self] isSelected, model in
                if let model {
                    self?.viewModel.updateExistingModel(isFavorite: isSelected, model: model)
                }
            }
            return cell
        }
        
        return .init(frame: .zero)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == viewModel.photos.count - 1 {
            viewModel.performFetchingPhotos()
        }
        
    }
    
}

extension PhotoGalleryViewController: UICollectionViewDelegate {
    
    
    
}
