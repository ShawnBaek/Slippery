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
    case second
    case third
    case fourth
    case fifth
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


@available(iOS 11.0, *)
public class SlipperyFlowLayout: UICollectionViewFlowLayout {
    private var lastCollectionViewSize: CGSize = .zero
    
    private var baseOffset: CGFloat = 200
    public var minimumScaleFactor: CGFloat = 0.5
    public var minimumOpacityFactor: CGFloat = 0.5
    
    private var pageWidth: CGFloat = 0 {
        didSet {
            baseOffset = pageWidth
        }
    }
    
    private var itemCenter: CGFloat = 0
    private var boundsCenter: CGFloat = 0
    private var customOffset: CGFloat = 0
    
    private var highlightOffsetForCell: HighlightItem = .center(.normal)
    public var initialOffset: CGFloat = 0
    
    public static func configureLayout(
        collectionView: UICollectionView,
        itemSize: CGSize,
        minimumLineSpacing: CGFloat,
        highlightOption: HighlightItem = .center(.normal)
    ) -> SlipperyFlowLayout {
        let layout = SlipperyFlowLayout()
        assert(
            itemSize.height.isLessThanOrEqualTo(collectionView.bounds.height),
            "Item height should be less then collectionView's height"
        )
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        layout.highlightOffsetForCell = highlightOption
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.collectionViewLayout = layout
        return layout
    }
    
    public func updateOffset(item: Int) -> CGFloat {
        guard let collectionView = self.collectionView else {
            return initialOffset
        }
        var updateOffset = CGFloat()
        let inset = collectionView.bounds.size.width / 2 - itemSize.width / 2
        let cropInset = -(itemSize.width - (inset - minimumLineSpacing))

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
        guard let collectionView = self.collectionView else {
            return
        }
        
        let inset = collectionView.bounds.size.width / 2 - itemSize.width / 2
        let cropInset = -(itemSize.width - (inset - minimumLineSpacing))
        
        pageWidth = itemSize.width + minimumLineSpacing
        itemCenter = itemSize.width / 2
        boundsCenter = self.collectionView!.bounds.size.width / 2
        switch option {
        case .center(let mode):
            if mode == .cropping {
                collectionView.contentInset = UIEdgeInsets.init(top: 0, left: cropInset, bottom: 0 , right: cropInset)
                collectionView.contentOffset = CGPoint(x: -cropInset, y: 0)
                initialOffset = pageWidth
            } else {
                collectionView.contentInset = UIEdgeInsets.init(top: 0, left: inset, bottom: 0 , right: inset)
                collectionView.contentOffset = CGPoint(x: -inset, y: 0)
                initialOffset = 0
            }
        case .custom(let base, let itemAt):
            collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            if base == .leading {
                customOffset = (pageWidth * CGFloat(itemAt.rawValue - 1)) + itemCenter
                initialOffset = CGFloat(itemAt.rawValue - 1) * (itemSize.width + minimumLineSpacing) + (itemSize.width / 2)
                collectionView.contentOffset = CGPoint(x: customOffset, y: 0)
            }
        }
    }
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        guard let collectionView = self.collectionView else {
            return
        }
        let currentCollectionViewSize = collectionView.bounds.size
        if !currentCollectionViewSize.equalTo(lastCollectionViewSize) {
            self.configureInset(for: highlightOffsetForCell)
            self.lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        let collectionViewSize = collectionView.bounds.size
        let proposedRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionViewSize.width,
            height: collectionViewSize.height
        )
        
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
                if abs(attributesOffset - proposedOffset) < abs(candidateOffset - proposedOffset) {
                    candidateAttributes = attributes
                }
            case .center(_):
                if abs(attributes.center.x - proposedContentOffsetCenterX) < abs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                    candidateAttributes = attributes
                }
            }
        }
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = CGFloat()
        switch highlightOffsetForCell {
        case .custom:
            newOffsetX = (candidateAttributes?.frame.origin.x)! - pageWidth
        case .center:
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
        guard let collectionView = self.collectionView else {
            return super.layoutAttributesForElements(in: rect)
        }
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size
        
        let visibleRect = CGRect(x:contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        var visibleCenterX = CGFloat()
        
        switch highlightOffsetForCell {
        case .custom(_, _):
            visibleCenterX = visibleRect.minX
        case .center(_):
            visibleCenterX = visibleRect.midX
        }
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
        for attribute in superAttributes {
            let newAttributes = attribute.copy() as! UICollectionViewLayoutAttributes
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
