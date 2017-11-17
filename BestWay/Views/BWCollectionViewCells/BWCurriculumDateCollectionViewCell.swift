//
//  BWCurriculumDateCollectionViewCell.swift
//  BestWay
//
//  Created by solar on 17/7/23.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 左边和上边的日期cell
class BWCurriculumDateCollectionViewCell: UICollectionViewCell {
    // MARK: - 右边框
    @IBOutlet weak var rightBorder: UIView!
    // MARK: - 下边框
    @IBOutlet weak var buttomBorder: UIView!
    // MARK: - 日期label
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
