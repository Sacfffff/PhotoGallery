//
//  NSAttributedString.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 12.02.24.
//

import UIKit

enum TextStyle {
    
    case regular16
    case regular14
    case unknown
    
}

extension NSAttributedString {
    
    static func attrs(for style: TextStyle) -> [NSAttributedString.Key: Any] {
        let result: [NSAttributedString.Key: Any]
        switch style {
                
        case .regular16:
            result = NSAttributedString.Regular16
        case .regular14:
            result = NSAttributedString.Regular14
        case .unknown:
            result = [:]
        }
        
        return result
    }
    
    
    static func attrs(for style: TextStyle, color: UIColor) -> [NSAttributedString.Key: Any] {
        var result: [NSAttributedString.Key: Any] = self.attrs(for: style)
        result[.foregroundColor] = color
        return result
    }
    
}

private extension NSAttributedString {

    static var Regular16: [NSAttributedString.Key: Any] { get { return [ .font: UIFont.systemFont(ofSize: 16, weight: .regular) ] } }
    static var Regular14: [NSAttributedString.Key: Any] { get { return [ .font: UIFont.systemFont(ofSize: 14, weight: .regular) ] } }

}
