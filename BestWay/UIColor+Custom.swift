//
//  UIColor+Custom.swift
//  BestWay
//
//  Created by solar on 17/3/14.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// UIColor扩展公共工具类
extension UIColor {
    // MARK: - 用16进制代码选择颜色
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
