//
//  TagCollectionViewLayout.swift
//  TagCollectionView
//
//  Created by ios on 16/2/16.
//  Copyright © 2016年 might. All rights reserved.
//

import UIKit

protocol TagCollectionViewLayoutDelegate {
    func itemWidth(collectionView:UICollectionView, collectionViewLayout:TagCollectionViewLayout, indexPath: NSIndexPath) -> CGFloat
//    func referenceSizeForHeader(collectionView:UICollectionView, collectionViewLayout:TagCollectionViewLayout, section: NSInteger) -> CGSize
//    func referenceSizeForFooter(collectionView:UICollectionView, collectionViewLayout:TagCollectionViewLayout, section: NSInteger) -> CGSize
}

class TagCollectionViewLayout: UICollectionViewLayout {

    var sectionInset:UIEdgeInsets!
    var lineSpacing:CGFloat!
    var itemSpacing:CGFloat!
    var itemHeight:CGFloat!
    var delegte:TagCollectionViewLayoutDelegate!
    
    private var endPoint:CGPoint!
    private var count:NSInteger!
    private var insertIndexPaths:NSMutableArray!
    private var deleteIndexPaths:NSMutableArray!
    
    
    override func prepareLayout() {
        super.prepareLayout()
        self.endPoint = CGPointZero
        self.count = self.collectionView?.numberOfItemsInSection(0)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func collectionViewContentSize() -> CGSize {
        var contentSize:CGSize!
        contentSize = CGSizeMake(CGRectGetWidth((self.collectionView?.frame)!), self.endPoint.y)
        return contentSize
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrsArray = NSArray()
        let temArray = NSMutableArray()
        for j:NSInteger in 0  ..< self.count  {
            let attrs:UICollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: j, inSection: 0))!
            temArray.addObject(attrs)
        }
        attrsArray = temArray.copy() as! NSArray
        return attrsArray as? [UICollectionViewLayoutAttributes]
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes:UICollectionViewLayoutAttributes? = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if self.insertIndexPaths .containsObject(itemIndexPath) {
            if attributes == nil {
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
                
                attributes!.alpha = 0.0;
                attributes!.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
            }
        }
        return attributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attr:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        var width:CGFloat = 0.0
        if self.delegte.itemWidth(self.collectionView!, collectionViewLayout: self, indexPath: indexPath) > 0 {
            width = self.delegte.itemWidth(self.collectionView!, collectionViewLayout: self, indexPath: indexPath)
        }
        let height:CGFloat = self.itemHeight
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        let judge = self.endPoint.x + width + self.itemSpacing + self.sectionInset.right
        if judge > CGRectGetWidth((self.collectionView?.frame)!) {
            x = self.sectionInset.left
            y = self.endPoint.y + self.lineSpacing
        }else {
            if indexPath.item == 0 {
                x = self.sectionInset.left
                y = self.sectionInset.top
            }else {
                x = self.endPoint.x + self.itemSpacing
                y = self.endPoint.y - height
            }
        }
        
        self.endPoint = CGPointMake(x + width, y + height)
        attr.frame = CGRectMake(x, y, width, height)
        
        return attr
    }
    
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        self.deleteIndexPaths = NSMutableArray()
        self.insertIndexPaths = NSMutableArray()
        for update:UICollectionViewUpdateItem in updateItems {
            if update.updateAction == UICollectionUpdateAction.Delete {
                self.deleteIndexPaths.addObject(update.indexPathBeforeUpdate!)
            }
            if update.updateAction == UICollectionUpdateAction.Insert {
                self.insertIndexPaths.addObject(update.indexPathAfterUpdate!)
            }
        }
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attris:UICollectionViewLayoutAttributes? = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        if self.deleteIndexPaths.containsObject(itemIndexPath) {
            if attris == nil {
                attris = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
                attris?.alpha = 0.0
                attris?.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0)
            }
        }
        return attris
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        self.insertIndexPaths = nil
        self.deleteIndexPaths = nil
    }
    
}
