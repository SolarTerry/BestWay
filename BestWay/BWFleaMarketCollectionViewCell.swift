//
//  BWFleaMarketCollectionViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/14.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 跳蚤市场单个商品cell
class BWFleaMarketCollectionViewCell: UICollectionViewCell {
    // MARK: - 商品首张图片
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - 商品价格背景图
    @IBOutlet weak var priceLabelBackground: UIImageView!
    
    // MARK: - 商品价格label
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - 商品标题label
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
