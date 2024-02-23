//
//  PhotoGalleryDetailViewController+ZoomViewController.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 21.02.24.
//

import Foundation

import UIKit

extension PhotoGalleryDetailViewController {
    
    class ZoomViewController: UIViewController {
        
        var isMinimumZoomScale: Bool {
            
            return image == nil || contentScrollView.minimumZoomScale == contentScrollView.zoomScale
        }
        
        private(set) var index = 0
        private var image: UIImage?
        
        private var contentScrollView = UIScrollView()
        private let imageView: UIImageView = UIImageView()
        private(set) var doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()

        
        convenience init(url: String, index: Int) {
            self.init()
            
            update(with: url, index: index)
            
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()

           setup()
            
        }

        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            updateFrame(with: view.bounds.size)
            
        }

        
        private func setup() {
            
            view.backgroundColor = theme.clear
            contentScrollView.backgroundColor = theme.clear
            imageView.backgroundColor = theme.clear
            
            contentScrollView.delegate = self
            contentScrollView.contentInsetAdjustmentBehavior = .never
            contentScrollView.showsVerticalScrollIndicator = false
            contentScrollView.showsHorizontalScrollIndicator = false
            view.addSubview(contentScrollView)
            
            imageView.contentMode = .scaleAspectFit
            contentScrollView.addSubview(imageView)
            
        }
        
        
        private func update(with url: String, index: Int) {
            
            self.index = index
            
            imageView.image = nil
            
            Task {
                if let image = await UIImage.loader.loadImage(with: url) {
                    self.image = image.resizedImageWithinRect(rectSize: self.view.bounds.size)
                    imageView.image = self.image
                    view.setNeedsLayout()
                    view.layoutIfNeeded()
                } else {
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage.noImage
                }
            }
            
            doubleTapGesture = UITapGestureRecognizer()
            doubleTapGesture.numberOfTapsRequired = 2
            doubleTapGesture.addTarget(self, action: #selector(onDoubleTapGestureEvent(_:)))
            view.addGestureRecognizer(doubleTapGesture)
            
        }
        

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            contentScrollView.frame = view.bounds
            let imageSize = image?.size.sizeInRect(rectSize: view.bounds.size, fit: true) ?? .zero
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: imageSize.width, height: imageSize.height)
            
            updateZoomScale(with: view.bounds.size)
            updateFrame(with: view.bounds.size)
            
        }
        
        
        @objc private func onDoubleTapGestureEvent(_ sender: UITapGestureRecognizer) {
            
            let pointInView = sender.location(in: imageView)
            var newZoomScale = contentScrollView.maximumZoomScale

            if contentScrollView.zoomScale >= newZoomScale || abs(contentScrollView.zoomScale - newZoomScale) <= 0.01 {
                newZoomScale = contentScrollView.minimumZoomScale
            }

            let width = contentScrollView.bounds.width / newZoomScale
            let height = contentScrollView.bounds.height / newZoomScale
            let originX = pointInView.x - (width / 2.0)
            let originY = pointInView.y - (height / 2.0)

            let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
            contentScrollView.zoom(to: rectToZoomTo, animated: true)
            
        }
        
        
        private func updateZoomScale(with size: CGSize) {
            
            let widthScale = size.width / imageView.bounds.width
            let heightScale = size.height / imageView.bounds.height
            let minScale = min(widthScale, heightScale)
            contentScrollView.minimumZoomScale = minScale
            
            contentScrollView.zoomScale = minScale
            contentScrollView.maximumZoomScale = minScale * 4
            
        }
        
        
        private func updateFrame(with size: CGSize) {
            
            let y = max(0, (size.height - imageView.frame.height) / 2)
            let x = max(0, (size.width - imageView.frame.width) / 2)
            imageView.frame.origin = CGPoint(x: x, y: y)
            let contentHeight = y * 2 + imageView.frame.height
            view.layoutIfNeeded()
            contentScrollView.contentSize = CGSize(width: contentScrollView.contentSize.width, height: contentHeight)
            
        }

    }
    
}


extension PhotoGalleryDetailViewController.ZoomViewController : UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updateFrame(with: view.bounds.size)
        
    }

    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        updateFrame(with: view.bounds.size)
        
    }

    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        
        return false
        
    }

}
