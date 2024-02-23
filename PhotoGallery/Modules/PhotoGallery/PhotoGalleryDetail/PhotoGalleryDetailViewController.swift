//
//  PhotoGalleryDetailViewController.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 21.02.24.
//

import UIKit

class PhotoGalleryDetailViewController: UIViewController {
    
    var didTappedFavorite: PhotoGalleryViewController.PreviewImageCell.FavoriteDidTappedCompletion?
    
    private let viewModel: ViewModel
    
    private let containerView: UIView = UIView()
    private let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing: 20])
    private let bottomView = BottomView()
    
    
    init?(models: [Photo], selectedModelIndex: Int) {
        
        if !models.isEmpty {
            self.viewModel = ViewModel(models: models, selectedModelIndex: selectedModelIndex)
            super.init(nibName: nil, bundle: nil)
        } else {
            return nil
        }
     
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds

        let w: CGFloat = view.bounds.width
        var h: CGFloat = 1
        var y: CGFloat = view.bounds.height
        let x: CGFloat = 0
        
        pageController.view.frame = view.bounds
        
        h = 200
        y = containerView.bounds.height - h
        bottomView.frame = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    
    private func setup() {
        
        view.backgroundColor = theme.background
        setupBackButton()
        setupRightBarButtonItem()
        
        view.addSubview(containerView)
        
        pageController.willMove(toParent: self)
        addChild(pageController)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.didMove(toParent: self)
        pageController.view.backgroundColor = theme.clear
        if let zoomController = createZoomController(viewModel.currentIndex) {
            pageController.setViewControllers([zoomController], direction: .forward, animated: false, completion: nil)
        }
        containerView.addSubview(pageController.view)
        
        containerView.addSubview(bottomView)
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            self.updateColor(for: theme)
        })
        
    }
    
    
    private func setupBackButton() {
        
        let button = UIButton()
        button.setImage(UIImage.chevronBackward, for: .normal)
        button.tintColor = theme.black
        button.addAction(.init(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        button.sizeToFit()
        navigationItem.leftBarButtonItem = .init(customView: button)
        
    }
    
    
    private func setupRightBarButtonItem() {
        
        let button = UIButton()
        button.setImage(UIImage.heart?.withTintColor(theme.black, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage.selectedHeart, for: .selected)
        button.isSelected = viewModel.currentModel.isFavorite == true
        button.addAction(.init(handler: { [weak self] _ in
            if let self {
                button.isSelected = !button.isSelected
                self.didTappedFavorite?(button.isSelected, viewModel.currentModel)
            }
        }), for: .touchUpInside)
        button.sizeToFit()
        navigationItem.rightBarButtonItem = .init(customView: button)
        
    }
    
    
    private func updateColor(for theme: ColorTheme) {
        
        setupBackButton()
        setupRightBarButtonItem()
        
    }
    
}

extension PhotoGalleryDetailViewController {
    
    private func createZoomController(_ index: Int) -> ZoomViewController? {
        
        var controller : ZoomViewController? = nil
        if index >= 0 && index <= viewModel.models.count - 1 {
            if let url = viewModel.models[index].urls.regular {
                controller = ZoomViewController(url: url, index: index)
            }
        }
        
        return controller
        
    }
    
}

extension PhotoGalleryDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return createZoomController(viewModel.currentIndex - 1)
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return createZoomController(viewModel.currentIndex + 1)
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed, let controller = pageController.viewControllers?.first as? ZoomViewController {
            viewModel.updateCurrentIndex(controller.index)
            setupRightBarButtonItem()
        }
        
    }
    
}
