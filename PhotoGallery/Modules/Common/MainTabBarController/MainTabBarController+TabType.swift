//
//  MainTabBarController+TabType.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 27.02.24.
//

import UIKit

extension MainTabBarController {
    
    enum TabType {
        
        case home
        case favorites
        
        var controller: UIViewController {
            
            return switch self {
                case .home:
                    PhotoGalleryViewController()
                case .favorites:
                    FavoritesViewController()
            }
        }
        
        var title: String {
            
            return switch self {
                case .home:
                    NSLocalizedString("tabbar.home.tab.title", comment: "")
                case .favorites:
                    NSLocalizedString("tabbar.favorites.tab.title", comment: "")
            }
        }
        
        var image: UIImage? {
            
            return switch self {
                case .home:
                    UIImage.magnifyingGlass
                case .favorites:
                    UIImage.heart
            }
        }
        
    }
    
}
