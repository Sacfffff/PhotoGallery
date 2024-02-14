//
//  UIApplication.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 14.02.24.
//

import UIKit

extension UIApplication {
    
    static var keyWindowInterfaceOrientation: UIInterfaceOrientation {
        
        return AppRouter.keyWindow?.windowScene?.interfaceOrientation ?? .portrait
    }
    
}
