//
//  PhotoGalleryDetailViewController+BottomView.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 22.02.24.
//

import UIKit

extension PhotoGalleryDetailViewController {
    
    class BottomView: UIView {
        
        private let descriptionLabel: UILabel = UILabel()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
            
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            layout()
            
        }
        
        
        @discardableResult
        private func layout() -> CGFloat {
            
            let x : CGFloat = 16
            let y : CGFloat = 16
            let w : CGFloat = self.bounds.width - x * 2
            let h : CGFloat = descriptionLabel.sizeThatFits(.init(width: w, height: .greatestFiniteMagnitude)).height
            
            descriptionLabel.frame = CGRect(x: x, y: y, width: w, height: h)
            
            return descriptionLabel.frame.maxY
            
        }
        
        
        func update(with model: Photo) {
            
            descriptionLabel.attributedText = nil
            
            let mutableString = NSMutableAttributedString(string: configureDescription(for: model), attributes: NSAttributedString.attrs(for: .regular16, color: .white))
            if let username = model.user?.username, let range = mutableString.string.range(of: username) {
                let nsRange = NSRange(range, in: mutableString.string)
                mutableString.setAttributes(NSAttributedString.attrs(for: .regular16, color: theme.gray), range: nsRange)
            }
            descriptionLabel.attributedText = mutableString
            
            layout()
            
        }
        
        
        private func setup() {
            
            backgroundColor = theme.blur
            self.layer.cornerRadius = 16
            
            descriptionLabel.numberOfLines = 0
            addSubview(descriptionLabel)
            
            registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                self.updateColor(for: theme)
            })
            
        }
        
        
        private func configureDescription(for model: Photo) -> String {
            
            var resultString: String = ""
            
            if let description = model.description {
                resultString.append("\(description)")
            }
            
            if let location = model.location?.name {
                resultString.append("(\(location))")
            }
           
            return resultString
            
        }
        
        
        private func updateColor(for theme: ColorTheme) {
            
            backgroundColor = theme.blur
            
        }
        
        
        override func sizeToFit() {
            super.sizeToFit()
            
            self.frame.size.height = layout()
            
        }
        
    }
    
}
