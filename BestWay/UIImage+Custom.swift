//
//  UIImage+Custom.swift
//  BestWay
//
//  Created by solar on 17/1/19.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// UIImage扩展公共工具类
extension UIImage{
    // MARK: - 修改图片大小方法
    func setImageSize(_ size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 生成纯颜色图片
    func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
