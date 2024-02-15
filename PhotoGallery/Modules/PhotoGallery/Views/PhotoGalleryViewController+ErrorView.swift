//
//  PhotoGalleryViewController+ErrorView.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 12.02.24.
//

import UIKit

extension PhotoGalleryViewController {
    
    class ErrorView: UIView {
        
        var actionHandler: (() -> Void)?
        
        private let imageView : UIImageView = UIImageView()
        private let title : UILabel = UILabel()
        private let button : UIButton = UIButton(configuration: .plain())
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.setup()
            
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            var h : CGFloat = 40
            var w : CGFloat = 40
            var y : CGFloat = bounds.midY - h / 2 - 40
            var x : CGFloat = bounds.midX - w / 2
            
            imageView.frame = CGRect(x: x, y: y, width: w, height: h)
            
            y = imageView.frame.maxY + 12
            x = 40
            w = bounds.width - x * 2
            h = title.sizeThatFits(.init(width: w, height: .greatestFiniteMagnitude)).height
            title.frame = CGRect(x: x, y: y, width: w, height: h)
            
            button.sizeToFit()
            
            h = 20
            y = title.frame.maxY + 12
            w = button.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: h)).width
            x = bounds.midX - w / 2
           
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            
        }
        
        
        private func setup() {
            
            imageView.image = UIImage.error
            imageView.tintColor = .theme.gray
            imageView.contentMode = .scaleAspectFill
            addSubview(imageView)
            
            title.attributedText = NSAttributedString(string: NSLocalizedString("gallery.error.title", comment: ""), attributes: NSAttributedString.attrs(for: .regular16, color: .theme.gray))
            title.numberOfLines = 0
            title.textAlignment = .center
            addSubview(title)
            
            button.setAttributedTitle(NSAttributedString(string: NSLocalizedString("gallery.error.button.title", comment: ""), attributes: NSAttributedString.attrs(for: .regular16)), for: .normal)
            button.setImage(UIImage.arrowClockwise, for: .normal)
            button.tintColor = .theme.gray
            button.configuration?.imagePadding = 8
            button.contentHorizontalAlignment = .left
            button.tintAdjustmentMode = .normal
            button.addAction(.init(handler: { [weak self] _ in
                self?.actionHandler?()
            }), for: .touchUpInside)
            addSubview(button)
        
        }
        
    }
    
}
