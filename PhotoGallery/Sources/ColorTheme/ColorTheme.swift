//
//  ColorTheme.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 23.02.24.
//

import UIKit

public enum ThemeType {
    
    case standard
    case dark
    
}

public class Theme: UITraitDefinition {
    
    static public var defaultValue: ColorTheme {
        
        return currentTheme()
    }
    
    static var type: ThemeType {
        
        return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .standard
    }
    
    static let standard: ColorThemeLight = ColorThemeLight()
    static let dark: ColorThemeDark = ColorThemeDark()
    
    private static func currentTheme() -> ColorTheme {
        
        return type == .standard ? standard : dark
    }
    
}

public var theme: ColorTheme {
    
    get {
        
        return Theme.defaultValue
    }
}

public protocol ColorTheme {
    
    var gray: UIColor {get}
    var background: UIColor {get}
    var red: UIColor {get}
    var clear: UIColor {get}
    var black: UIColor {get}
    
}


public struct ColorThemeLight: ColorTheme {
    
    public let gray = UIColor.gray.withAlphaComponent(0.7)
    public let background = UIColor.systemBackground
    public let red = UIColor.red.withAlphaComponent(0.8)
    public let clear = UIColor.clear
    public let black = UIColor.black
    
}

public struct ColorThemeDark: ColorTheme {
    
    public let gray = UIColor.gray.withAlphaComponent(0.7)
    public let background = UIColor.systemBackground
    public let red = UIColor.red.withAlphaComponent(0.8)
    public let clear = UIColor.clear
    public let black = UIColor.white
    
}
