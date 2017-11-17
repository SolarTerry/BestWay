//
//  BWSituationAndPolicyTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/22.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 形势与政策信息cell
class BWSituationAndPolicyTableViewCell: UITableViewCell {
    // 题目label
    @IBOutlet weak var titleLabel: UILabel!
    // 主讲人label
    @IBOutlet weak var teacherLabel: UILabel!
    // 时间label
    @IBOutlet weak var timeLabel: UILabel!
    // 地点label
    @IBOutlet weak var placeLabel: UILabel!
    // 题目label高度
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reloadData(title: String, teacher: String, time: String, place: String) {
        // 标题
        self.titleLabel.text = title
        // 使UILabel根据文字内容自适应高度
        var titleLabelSize = CGRect()
        titleLabelSize = labelSizeToFit(label: self.titleLabel, text: title, font: self.titleLabel.font)
        self.titleLabelHeight.constant = titleLabelSize.height
        
        // 主讲人
        self.teacherLabel.text = teacher
        
        // 时间
        self.timeLabel.text = time
        
        // 地点
        self.placeLabel.text = place
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - 使UILabel根据文字内容自适应高度
    func labelSizeToFit(label: UILabel, text: String, font: UIFont) -> CGRect {
        // 使UILabel里的文字换行
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.numberOfLines = 0
        let labelText: NSString = text as NSString
        let attributes = [NSFontAttributeName: font]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let labelSize = labelText.boundingRect(with: CGSize(width: label.frame.width, height: 0), options: options, attributes: attributes, context: nil)
        print("labelSize.height:\(labelSize.height)")
        return labelSize
    }
    
}
