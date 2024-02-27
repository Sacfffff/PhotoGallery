//
//  MainTabBarViewController.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 27.02.24.
//

import UIKit

class MainTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        
        setupControllers()
        
    }
    
    
    private func setupControllers() {
        
        self.viewControllers = [TabType.home, TabType.favorites].map { self.createNavigationController(tabType: $0) }
        
    }
    
    
    private func createNavigationController(tabType: TabType) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: tabType.controller)
        navController.tabBarItem.title = tabType.title
        navController.tabBarItem.image = tabType.image
        navController.tabBarItem.selectedImage = tabType.image
        navController.extendedLayoutIncludesOpaqueBars = false
        return navController
        
    }
    
}
