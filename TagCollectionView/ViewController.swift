//
//  ViewController.swift
//  TagCollectionView
//
//  Created by ios on 16/2/1.
//  Copyright © 2016年 might. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, TagCollectionViewLayoutDelegate, CollectionViewCellDelegate, AddConnectionViewItemDelegate
{
    
    var fakeDataArray:NSMutableArray!
    var collectionView:UICollectionView!
    var keyboardView:KeyBoardDisplayView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let array:Array = ["头条", "热点新闻", "热点新闻", "本地", "财经", "图片", "轻松一刻", "LOL", "段子手", "房产", "暴雪游戏帖", "家居", "原创大型喜剧", "游戏英雄联盟", "English"]
        self.fakeDataArray = NSMutableArray(array: array)
        self.configCollectionView()
        //添加键盘
        self.addKeyboardView()
    }
    
    func configCollectionView() {
        let tagLayout:TagCollectionViewLayout = TagCollectionViewLayout()
        tagLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        tagLayout.lineSpacing = 10
        tagLayout.itemSpacing = 10
        tagLayout.itemHeight = 30
        tagLayout.delegte = self
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64), collectionViewLayout: tagLayout)
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        
        self.collectionView.registerNib(UINib(nibName:"CollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"CollectionViewCell")
        self.collectionView.registerNib(UINib(nibName: "AddItemCell", bundle: nil), forCellWithReuseIdentifier: "AddItemCell")
        self.view.addSubview(self.collectionView)
        
        self.collectionView.reloadData()
    }
    
    //UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fakeDataArray.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < self.fakeDataArray.count {
            let cell:CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
            cell.contentLabel.text = self.fakeDataArray[indexPath.item] as? String
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
        else{
            let cell: AddItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("AddItemCell", forIndexPath: indexPath) as! AddItemCell
            cell.delegate = self
            return cell
        }
    }
    
    //TagCollectionViewLayoutDelgate
    func itemWidth(collectionView: UICollectionView, collectionViewLayout: TagCollectionViewLayout, indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < self.fakeDataArray.count {
            var size:CGSize = CGSizeZero
            size.height = 30
            let temSize:CGSize = self.sizeWithAString(self.fakeDataArray[indexPath.item] as! NSString, fontsize: 14)
            size.width = temSize.width + 20 + 1
            return size.width
        }
        else {
            return 90.0
        }
    }

    func sizeWithAString(string:NSString, fontsize:CGFloat) ->CGSize {
        let constraint:CGSize = CGSizeMake(self.view.frame.width - 40, fontsize + 1.0)
        let temSize:CGSize!
        
        let retSize:CGSize = string.boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(fontsize)], context: nil).size
        temSize = retSize
        return temSize
    }
    
    //CollectionViewCellDelegate
    func deleteAssignItem(indexPath: NSIndexPath) {
        self.fakeDataArray.removeObjectAtIndex(indexPath.item)
        
        self.collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
            }) { (finished:Bool) -> Void in
                self.updateIndexPath()
        }
    }
    
    //AddConnectionCellDelegate
    func addItem() {
        self.keyboardView .show()
    }
    
    func updateIndexPath() {
        for var i:Int = 0; i < self.fakeDataArray.count; i++ {
            let indexPath:NSIndexPath = NSIndexPath(forItem: i, inSection: 0)
            let cell:CollectionViewCell = self.collectionView .cellForItemAtIndexPath(indexPath) as! CollectionViewCell
            cell.indexPath = indexPath
        }
    }
    
    func addKeyboardView() {
        self.keyboardView = KeyBoardDisplayView.init(frame: CGRectMake(0, CGRectGetHeight(self.view.frame) - 64, CGRectGetWidth(self.view.frame), 50))
        self.keyboardView .resignKeyBoardNotics()
        
        self.view .addSubview(self.keyboardView)
        //将新增加内容导入数据源
        self.addItemData()
    }
    
    func addItemData() {
        self.keyboardView.sendTapBlock = {str in
            self.fakeDataArray .addObject(str)
            self.collectionView.performBatchUpdates({ () -> Void in
                self.collectionView .insertItemsAtIndexPaths([NSIndexPath.init(forItem: self.fakeDataArray.count - 1, inSection: 0)])
                }, completion: { (finished) -> Void in
                    self.keyboardView.hidden()
                    self.updateIndex()
            })
        }
    }
    
    func updateIndex() {
        for var i = 0; i < self.fakeDataArray.count; i++ {
            let indexPath = NSIndexPath.init(forItem: i, inSection: 0)
            let collectViewCell:CollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
            collectViewCell.indexPath = indexPath;
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardView.removeKeyboardNotics()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

