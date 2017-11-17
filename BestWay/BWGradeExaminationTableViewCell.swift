//
//  BWGradeExaminationTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/29.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 等级考试信息cell
class BWGradeExaminationTableViewCell: UITableViewCell {
    // MARK: - 考试名称
    @IBOutlet weak var examinationLabel: UILabel!
    // MARK: - 准考证号
    @IBOutlet weak var admissionTicketNumberLabel: UILabel!
    // MARK: - 考试时间
    @IBOutlet weak var examinationTimeLabel: UILabel!
    // MARK: - 考试地点
    @IBOutlet weak var examinationRoomLabel: UILabel!
    // MARK: - 座位号
    @IBOutlet weak var seatNumberLabel: UILabel!
    // MARK: - 考试成绩
    @IBOutlet weak var gradeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
