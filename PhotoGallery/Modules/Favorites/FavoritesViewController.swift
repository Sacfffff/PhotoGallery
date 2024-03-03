//
//  FavoritesViewController.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 27.02.24.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController {
    
    private let viewModel = ViewModel()
    
    private let infoLabel: UILabel = UILabel()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: PreviewImageCellLayout())
    
    private var cancelBag: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
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
        
        let x : CGFloat = 20
        let w : CGFloat = view.bounds.width - x * 2
        let h : CGFloat = infoLabel.sizeThatFits(.init(width: w, height: .greatestFiniteMagnitude)).height
        let y : CGFloat = view.frame.midY - h / 2
        
        infoLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        collectionView.frame = view.bounds
        
    }
    
    
    private func setup() {
        
        view.backgroundColor = theme.background
        title = NSLocalizedString("tabbar.favorites.tab.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        (collectionView.collectionViewLayout as? PreviewImageCellLayout)?.isPortraitOrientation = UIApplication.keyWindowInterfaceOrientation.isPortrait
        collectionView.contentInset = .init(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PreviewImageCell.self, forCellWithReuseIdentifier: "\(PreviewImageCell.self)")
        view.addSubview(collectionView)
        
        infoLabel.attributedText = NSAttributedString(string: NSLocalizedString("info.label.favorites", comment: ""), attributes: NSAttributedString.attrs(for: .semibold16, color: theme.gray))
        infoLabel.numberOfLines = 0
        view.addSubview(infoLabel)
        
        viewModel.$photos
            .sink { [weak self] photos in
                UIView.setAnimationsEnabled(false)
                self?.collectionView.reloadData()
                UIView.setAnimationsEnabled(true)
                self?.infoLabel.isHidden = !photos.isEmpty
            }
            .store(in: &cancelBag)
        
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        (collectionView.collectionViewLayout as? PreviewImageCellLayout)?.isPortraitOrientation = UIApplication.keyWindowInterfaceOrientation.isPortrait
        collectionView.collectionViewLayout.invalidateLayout()
        layout()
        
    }
    
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.photos.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PreviewImageCell.self)", for: indexPath) as? PreviewImageCell {
            cell.update(with: viewModel.photos[indexPath.row])
            cell.actionHandler = { [weak self] _, model in
                if let model {
                    self?.viewModel.update(with: model)
                }
            }
            return cell
        }
        
        return .init(frame: .zero)
        
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let detailViewController = PhotoGalleryDetailViewController(models: viewModel.photos, selectedModelIndex: indexPath.row, canTapFavorite: false) {
            detailViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
    }
    
}
