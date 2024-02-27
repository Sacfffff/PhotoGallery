//
//  PhotoGalleryViewController+PreviewImageCellLayout.swift
//  PhotoGallery
//
//  Created by Alexandra Kravtsova on 14.02.24.
//

import UIKit
    
final class PreviewImageCellLayout: UICollectionViewLayout {
    
    enum PreviewImageCellLayoutSegmentStyle {
        
        case fullWidth
        case halfWidth
        
    }
    
    var isPortraitOrientation: Bool = true
    
    private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    
    private var contentBounds = CGRect.zero
    private(set) var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        
        return contentBounds.size
    }
    
    
    override func prepare() {
        super.prepare()
        
        cachedAttributes.removeAll()
        
        if let collectionView {
            contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
            
            let count = collectionView.numberOfItems(inSection: 0)
            var currentIndex = 0
            
            var segmentStyle: PreviewImageCellLayoutSegmentStyle = .fullWidth
            var lastFrame: CGRect = .zero
            while currentIndex < count {
                let itemHeight = isPortraitOrientation ? collectionView.bounds.height / 5.0 : collectionView.bounds.height
                let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + (currentIndex == 0 ? 0 : inset.top), width: collectionView.bounds.width, height: itemHeight)
                var segmentRects = [CGRect]()
                if segmentStyle == .fullWidth {
                    segmentRects = [segmentFrame]
                } else {
                    let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge, inset: inset.left)
                    segmentRects = [horizontalSlices.first, horizontalSlices.second]
                }
                
                for rect in segmentRects {
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                    attributes.frame = rect
                    
                    cachedAttributes.append(attributes)
                    contentBounds = contentBounds.union(rect)
                    currentIndex += 1
                    lastFrame = rect
                }
                
                segmentStyle = segmentStyle == .fullWidth ? .halfWidth : .fullWidth
            }
        }
        
    }
    
    
    override func invalidateLayout() {
        
        super.invalidateLayout()
        cachedAttributes.removeAll()
        
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        var result = false
        if let collectionView {
            result = !newBounds.size.equalTo(collectionView.bounds.size)
        }
        return result
        
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cachedAttributes[indexPath.item]
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        if let lastIndex = cachedAttributes.indices.last, let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) {
            for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
                if attributes.frame.maxY >= rect.minY {
                    attributesArray.append(attributes)
                } else {
                    break
                }
            }
            for attributes in cachedAttributes[firstMatchIndex...] {
                if attributes.frame.minY <= rect.maxY {
                    attributesArray.append(attributes)
                } else {
                    break
                }
            }
        }
        return attributesArray
        
    }
    
    
    private func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        
        var result: Int?
        if end >= start {
            let mid = (start + end) / 2
            let attr = cachedAttributes[mid]
            if attr.frame.intersects(rect) {
                result = mid
            } else {
                if attr.frame.maxY < rect.minY {
                    result = binSearch(rect, start: (mid + 1), end: end)
                } else {
                    result = binSearch(rect, start: start, end: (mid - 1))
                }
            }
        }
        return result
        
    }
    
}


fileprivate extension CGRect {
    
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge, inset: CGFloat) -> (first: CGRect, second: CGRect) {
        
        let dimension: CGFloat
        
        switch fromEdge {
            case .minXEdge, .maxXEdge:
                dimension = self.size.width
            case .minYEdge, .maxYEdge:
                dimension = self.size.height
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
            case .minXEdge, .maxXEdge:
                slices.remainder.origin.x += inset
                slices.remainder.size.width -= inset
            case .minYEdge, .maxYEdge:
                slices.remainder.origin.y += inset
                slices.remainder.size.height -= inset
        }
        return (first: slices.slice, second: slices.remainder)
        
    }
    
}
