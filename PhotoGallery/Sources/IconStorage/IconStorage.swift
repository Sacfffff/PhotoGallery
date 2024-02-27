//
//  IconStorage.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 15.02.24.
//

import UIKit

extension UIImage {
    
    static var magnifyingGlass: UIImage? { UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)}
    static var heart: UIImage? { UIImage(systemName: "heart") }
    static var selectedHeart: UIImage? { UIImage(systemName: "heart.fill")?.withTintColor(theme.red, renderingMode: .alwaysOriginal) }
    static var error: UIImage? { UIImage(systemName: "circle.slash")?.withRenderingMode(.alwaysTemplate) }
    static var arrowClockwise: UIImage? { UIImage(systemName: "arrow.clockwise") }
    static var noImage: UIImage? { UIImage(systemName: "rectangle.slash")?.withTintColor(theme.gray, renderingMode: .alwaysOriginal) }
    static var chevronBackward: UIImage? { UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)}
    
}
