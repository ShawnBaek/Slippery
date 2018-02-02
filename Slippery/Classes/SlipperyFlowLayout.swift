//
//  SlipperyFlowLayout.swift
//  Pods-Slippery_Example
//
//  Created by BaekSungwook on 1/28/18.
//

import UIKit

public enum Base {
    case leading
    
}

public enum ItemAt : Int {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
    case fifth = 5
}

//typealias ItemAt = Base.ItemAt

public enum Center {
    case cropping
    case normal
}

//Cell Highlight Position
public enum HighlightItem {
    case center(Center)
    case custom(Base, ItemAt)
}


@available(iOS 10.0, *)
public class SlipperyFlowLayout: UICollectionViewFlowLayout {
    
    private var lastCollectionViewSize: CGSize = .zero
    
    private var baseOffset: CGFloat = 200
    public var minimumScaleFactor: CGFloat = 0.5
    public var minimumOpacityFactor: CGFloat = 0.5
    
    public var pageCount: Int = 0
    
    private var pageWidth: CGFloat = 0 {
        didSet {
            baseOffset = pageWidth
        }
    }
    
    private var itemCenter: CGFloat = 0
    private var boundsCenter: CGFloat = 0
    private var customOffset: CGFloat = 0
    
    public var highlightOffsetForCell: HighlightItem = HighlightItem.center(.normal)
    public var initialOffset: CGFloat = 0
    
    
    public static func configureLayout(collectionView: UICollectionView, itemSize: CGSize, minimumLineSpacing: CGFloat, highlightOption: HighlightItem) -> SlipperyFlowLayout {
        
        let layout = SlipperyFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        layout.highlightOffsetForCell = highlightOption
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.collectionViewLayout = layout
        
        return layout
    }
    
    public func updateOffset(item: Int) -> CGFloat {
        
        if self.collectionView == nil {
            return initialOffset
        }
        
        var updateOffset = CGFloat()
        
        let inset = self.collectionView!.bounds.size.width / 2 - self.itemSize.width / 2
        let cropInset = -(self.itemSize.width - (inset - self.minimumLineSpacing))

        switch highlightOffsetForCell {
        case .center(let mode):
            if mode == .cropping {
                updateOffset = -cropInset + initialOffset + CGFloat(item  - 2) * pageWidth
            }else {
                updateOffset = -inset + initialOffset + CGFloat(item) * pageWidth
            }
        case .custom(let base, let itemAt):
    
            
            if base == .leading {
               
                guard item - itemAt.rawValue > 0 else { return initialOffset }
                updateOffset = initialOffset + (pageWidth * CGFloat(item - itemAt.rawValue - 1)) - itemCenter
            }
            
        }
        
        return updateOffset
        
    }
    
    private func configureInset(for option: HighlightItem) {
        if self.collectionView == nil {
            return
        }
        
        let inset = self.collectionView!.bounds.size.width / 2 - self.itemSize.width / 2
        let cropInset = -(self.itemSize.width - (inset - self.minimumLineSpacing))
        
        pageWidth = itemSize.width + minimumLineSpacing
        itemCenter = itemSize.width / 2
        boundsCenter = self.collectionView!.bounds.size.width / 2
        
        switch option {
        case .center(let mode):
            if mode == .cropping {
                self.collectionView!.contentInset = UIEdgeInsetsMake(0, cropInset, 0 , cropInset)
                self.collectionView!.contentOffset = CGPoint(x: -cropInset, y: 0)
                initialOffset = pageWidth
            }else {
                self.collectionView!.contentInset = UIEdgeInsetsMake(0, inset, 0 , inset)
                self.collectionView!.contentOffset = CGPoint(x: -inset, y: 0)
                initialOffset = 0
                
            }
        case .custom(let base, let itemAt):
            
            self.collectionView!.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            
            if base == .leading {
                customOffset = (pageWidth * CGFloat(itemAt.rawValue - 1)) + itemCenter
                initialOffset = CGFloat(itemAt.rawValue - 1) * (itemSize.width + minimumLineSpacing) + (itemSize.width / 2)
                
                self.collectionView?.contentOffset = CGPoint(x: customOffset, y: 0)
            }
            
        }
    }
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        if self.collectionView == nil {
            return
        }
        
        let currentCollectionViewSize = self.collectionView!.bounds.size
        if !currentCollectionViewSize.equalTo(self.lastCollectionViewSize) {
            self.configureInset(for: highlightOffsetForCell)
            self.lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if self.collectionView == nil {
            return proposedContentOffset
        }
        
        let collectionViewSize = self.collectionView!.bounds.size
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        let layoutAttributes = self.layoutAttributesForElements(in: proposedRect)
        
        if layoutAttributes == nil {
            return proposedContentOffset
        }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        var proposedContentOffsetCenterX = CGFloat()
        
        switch highlightOffsetForCell {
        case .custom(_, _) :
            proposedContentOffsetCenterX = proposedContentOffset.x + pageWidth
        case .center(_):
            proposedContentOffsetCenterX = proposedContentOffset.x + boundsCenter
        }
        
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
            if attributes.representedElementCategory != .cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            switch highlightOffsetForCell {
            case .custom(_, _):
                let attributesOffset = attributes.frame.origin.x + pageWidth
                let candidateOffset = (candidateAttributes?.frame.origin.x)! + pageWidth
                let proposedOffset = proposedContentOffsetCenterX + pageWidth
                
                if fabs(attributesOffset - proposedOffset) < fabs(candidateOffset - proposedOffset) {
                    candidateAttributes = attributes
                }
            case .center(_):
                if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                    candidateAttributes = attributes
                }
            }
        }
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = CGFloat()
        switch highlightOffsetForCell {
        case .custom(_, _):
            newOffsetX = (candidateAttributes?.frame.origin.x)! - pageWidth
        case .center(_):
            newOffsetX = candidateAttributes!.center.x - boundsCenter
        }
        
        let offset = newOffsetX - self.collectionView!.contentOffset.x
        
        if(velocity.x < 0 && offset > 0 ) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth: -pageWidth
        }
       
        
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
//        if !self.scaleItems || self.collectionView == nil {
//            return super.layoutAttributesForElements(in: rect)
//        }
        if self.collectionView == nil {
            return super.layoutAttributesForElements(in: rect)
        }
        
        let superAttributes = super.layoutAttributesForElements(in: rect)
        
        if superAttributes == nil {
            return nil
        }
        
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size
        
        
        let visibleRect = CGRect(x:contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        
        var visibleCenterX = CGFloat()
        
        switch highlightOffsetForCell {
        case .custom(_, _):
            visibleCenterX = visibleRect.minX
            
        case .center(_):
            visibleCenterX = visibleRect.midX
        }
        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
        
        for (_, attributes) in superAttributes!.enumerated(){
            
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            var distanceFromCenter = CGFloat()
            
            switch highlightOffsetForCell {
                
            case .custom(_, _):
                distanceFromCenter = visibleCenterX - newAttributes.center.x + customOffset
                
            case .center(_):
                distanceFromCenter = visibleCenterX - newAttributes.center.x
                
            }
            
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.baseOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.baseOffset + 1
            let opacity = absDistanceFromCenter * (self.minimumOpacityFactor - 1) / self.baseOffset + 1
            
            
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            newAttributes.alpha = opacity
            
        }
        
        return newAttributesArray
        
        
    }
    
    
    
    
}
