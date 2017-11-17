//
//  BWSegmentPatten.swift
//  BestWay
//
//  Created by solar on 17/3/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit

class BWSegmentPattern {
    // MARK: - item字体颜色
    static let itemTextColor = UIColor.gray
    // MARK: - 选中item字体颜色
    static let itemSelectedTextColor = UIColor.colorFromRGB(0x6d9eeb).withAlphaComponent(0.5)
    // MARK: - item背景色
    static let itemBackgroundColor = UIColor.colorFromRGB(0xa4c2f4).withAlphaComponent(0.1)
    // MARK: - 选中item背景色
    static let itemSelectedBackgroundColor = UIColor.colorFromRGB(0xa4c2f4).withAlphaComponent(0.3)
    // MARK: - item边框
    static let itemBorder : CGFloat = 20.0
    // MARK: - item字体
    static let textFont = UIFont.systemFont(ofSize: 16.0)
    // MARK: - 选中item字体
    static let selectedTextFont = UIFont.boldSystemFont(ofSize: 19.0)
    // MARK: - 滑动条
    static let sliderColor = UIColor.colorFromRGB(0x54a6f2)
    // MARK: - 滑动条高度
    static let sliderHeight : CGFloat = 5.0
    // MARK: - item上的小红点
    static let bridgeColor = UIColor.red
    // MARK: - item上的小红点宽度
    static let bridgeWidth : CGFloat = 7.0
    // MARK: - inline func
    @inline(__always) static func color(red:Float, green:Float, blue:Float, alpha:Float) -> UIColor {
        return UIColor(colorLiteralRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }

}
