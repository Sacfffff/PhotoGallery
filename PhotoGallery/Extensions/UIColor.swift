//
//  UIColor.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 12.02.24.
//

import UIKit

extension UIColor {
    
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    
    let gray = UIColor.gray.withAlphaComponent(0.7)
    let background = UIColor.systemBackground
    let red = UIColor.red.withAlphaComponent(0.8)
    let clear = UIColor.clear
}
