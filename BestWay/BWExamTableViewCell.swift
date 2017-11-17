//
//  BWExamTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/21.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 考试信息cell
class BWExamTableViewCell: UITableViewCell {
    // 考试科目label
    @IBOutlet weak var examLabel: UILabel!
    // 考试时间label
    @IBOutlet weak var timeLabel: UILabel!
    // 考试地点label
    @IBOutlet weak var placeLabel: UILabel!
    // 座位号label
    @IBOutlet weak var seatNumberLabel: UILabel!
    // 倒计时label
    @IBOutlet weak var countDownLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
