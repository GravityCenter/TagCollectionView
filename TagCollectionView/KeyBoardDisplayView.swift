//
//  KeyBoardDisplayView.swift
//  TagCollectionView
//
//  Created by ios on 16/2/29.
//  Copyright © 2016年 might. All rights reserved.
//

import UIKit

typealias tapBlock = (NSString) -> Void

class KeyBoardDisplayView: UIView {

    var textField: UITextField!
    var sendButton: UIButton!
    var sendTapBlock: tapBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSubviews()
        self.backgroundColor = UIColor(red: 240.0/250.0, green: 240.0/250.0, blue: 240.0/250.0, alpha: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configSubviews()
        self.backgroundColor = UIColor(red: 240.0/250.0, green: 240.0/250.0, blue: 240.0/250.0, alpha: 1.0)
    }
    
    func configSubviews() {
        self.textField = UITextField.init(frame: CGRectMake(10, 5, CGRectGetWidth(self.frame) - 90, CGRectGetHeight(self.frame) - 10))
        self.textField.layer.masksToBounds = true
        self.textField.layer.cornerRadius  = 2
        self.textField.layer.borderColor   = UIColor.lightGrayColor().CGColor
        self.textField.layer.borderWidth   = 0.8
        self.textField.placeholder = "请输入标签内容"
        
        self.sendButton = UIButton.init(frame: CGRectMake(20 + CGRectGetWidth(self.textField.frame), 5, 60, CGRectGetHeight(self.frame) - 10))
        self.sendButton.layer.masksToBounds = true
        self.sendButton.layer.cornerRadius  = 2
        self.sendButton.layer.borderColor   = UIColor.redColor().CGColor
        self.sendButton.layer.borderWidth   = 0.8
        self.sendButton.setTitle("发送", forState: UIControlState.Normal)
        self.sendButton.addTarget(self, action: "sendAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.textField)
        self.addSubview(self.sendButton)
}
    
    func sendAction() {
        let exsistBlock = self.sendTapBlock
        if (exsistBlock != nil) {
            self.sendTapBlock!(self.textField.text!)
        }
    }
    
    func resignKeyBoardNotics() {
        //注册键盘通知
        let notificationCeter = NSNotificationCenter.defaultCenter()
        notificationCeter.addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCeter.addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func removeKeyboardNotics() {
        //移除键盘通知
        NSNotificationCenter.defaultCenter() .removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter() .removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyBoardWillShow(noti: NSNotification) {
        let dic:NSDictionary = noti.userInfo!
        let keyBoardSize:CGSize = (dic.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue.size)!
        let view:UIView = self.superview!
        self.frame = CGRectMake(0, CGRectGetHeight(view.frame) - keyBoardSize.height - 50, CGRectGetWidth(view.frame), 50)
    }
    
    func keyBoardWillHide(noti: NSNotification) {
        let view:UIView = self.superview!
        self.frame = CGRectMake(0, CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), 50)
    }
    
    func show() {
        self.textField.becomeFirstResponder()
    }
    
    func hidden() {
        self.textField.text = ""
        self.superview?.endEditing(true)
    }
}
