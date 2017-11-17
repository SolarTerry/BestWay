//
//  BWCardTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/1/21.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 快递中心单个快递点快递列表cell
class BWCardTableViewCell: UITableViewCell {
    // MARK: - 卡片背景图
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: - 卡片用户头像
    @IBOutlet weak var userLogo: UIImageView!
    
    // MARK: - 卡片用户名
    @IBOutlet weak var userName: UILabel!
    
    // MARK: - 卡片发布时间
    @IBOutlet weak var releaseTime: UILabel!
    
    // MARK: - 帮代领按钮
    @IBOutlet weak var button: UIButton!
    
    // MARK: - 快递信息label
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - 卡片状态图
    @IBOutlet weak var status: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
