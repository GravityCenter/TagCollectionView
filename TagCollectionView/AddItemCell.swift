//
//  AddItemCell.swift
//  TagCollectionView
//
//  Created by ios on 16/2/29.
//  Copyright © 2016年 might. All rights reserved.
//

import UIKit

protocol AddConnectionViewItemDelegate {
    func addItem()
}

class AddItemCell: UICollectionViewCell {
    var delegate:AddConnectionViewItemDelegate!
    
    @IBAction func addItemAction(sender: AnyObject) {
        self.delegate .addItem()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
