//
//  BWAddPhotoCollectionViewCell.swift
//  BestWay
//
//  Created by solar on 17/4/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 已选择的图片缩略图cell
class BWAddPhotoCollectionViewCell: UICollectionViewCell {
    // 已选择的图片
    var imageView: UIImageView!
    
    // 删除按钮
    var button = UIButton()
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置缩略图大小
        imageView = UIImageView(frame: self.bounds)
        
        // 设置按钮属性
        button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
        button.frame = CGRect(x: frame.size.width - 21, y: 1, width: 20, height: 20)
        
        self.addSubview(imageView)
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
