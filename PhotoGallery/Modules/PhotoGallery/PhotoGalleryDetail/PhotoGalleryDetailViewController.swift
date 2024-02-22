//
//  PhotoGalleryDetailViewController.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 21.02.24.
//

import UIKit

class PhotoGalleryDetailViewController: UIViewController {
    
    private let viewModel: ViewModel
    
    private let containerView: UIView = UIView()
    private let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing: 20])
    
    
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
        let h: CGFloat = 1
        let y: CGFloat = view.bounds.height
        let x: CGFloat = 0
        
        pageController.view.frame = view.bounds
        
    }
    
    
    private func setup() {
        
        view.backgroundColor = .theme.background
        
        view.addSubview(containerView)
        
        pageController.willMove(toParent: self)
        addChild(pageController)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.didMove(toParent: self)
        pageController.view.backgroundColor = .theme.clear
        if let zoomController = createZoomController(viewModel.currentIndex) {
            pageController.setViewControllers([zoomController], direction: .forward, animated: false, completion: nil)
        }
        containerView.addSubview(pageController.view)
        
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
        }
        
    }
    
}
