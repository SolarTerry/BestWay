//
//  BWScoreTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/19.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 单个课程成绩cell
class BWScoreTableViewCell: UITableViewCell {
    // MARK: - 课程和学分label
    @IBOutlet weak var courseAndCreditLabel: UILabel!
    // MARK: - 课程时间label
    @IBOutlet weak var courseTimeLabel: UILabel!
    // MARK: - 成绩和绩点label
    @IBOutlet weak var scoreAndGPALabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
