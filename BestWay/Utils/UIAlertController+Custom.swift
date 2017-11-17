//
//  UIViewcontroller+Custom.swift
//  BestWay
//
//  Created by 万志强 on 16/12/3.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import Foundation

import UIKit
// UIAlertController扩展公共工具类
extension UIAlertController {
    
    // MARK: - 生成带取消按钮的普通alertController
    class func alertControllerWithTitle(_ title:String, msg:String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        
        return controller
    }
    

    // MARK: - 生成带回调方法的alertController
    class func alertControllerWithAction(_ title:String, msg:String,actionTitle:String,action:@escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: actionTitle, style: .default, handler:action))
        
        return controller
    }
    
    
    // MARK: - 生成带回调方法,不可取消的alertController
    class func alertControllerWithActionNoCancel(_ title:String, msg:String,actionTitle:String,action:@escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: actionTitle, style: .default, handler:action))
        
        return controller
    }
}
