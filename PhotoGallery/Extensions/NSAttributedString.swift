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
    case semibold16
    case unknown
    
}

extension NSAttributedString {
    
    static func attrs(for style: TextStyle) -> [NSAttributedString.Key: Any] {
        
        return switch style {
            case .regular16:
                NSAttributedString.Regular16
            case .regular14:
                NSAttributedString.Regular14
            case .semibold16:
                NSAttributedString.Semibold16
            case .unknown:
                [:]
        }
        
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
    static var Semibold16: [NSAttributedString.Key: Any] { get { return [ .font: UIFont.systemFont(ofSize: 16, weight: .semibold) ] } }

}
