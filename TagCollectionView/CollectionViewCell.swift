//
//  CollectionViewCell.swift
//  TagCollectionView
//
//  Created by ios on 16/2/16.
//  Copyright © 2016年 might. All rights reserved.
//

import UIKit
protocol CollectionViewCellDelegate {
    func deleteAssignItem(indexPath:NSIndexPath)
}

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var delegate:CollectionViewCellDelegate!
    var indexPath:NSIndexPath!
    
    @IBAction func deleteItem() {
        self.delegate.deleteAssignItem(self.indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.layer.masksToBounds = true
        self.backView.layer.cornerRadius  = 5.0
        self.backView.layer.borderWidth   = 0.5
        self.backView.layer.borderColor   = UIColor.darkGrayColor().CGColor
    }

}
