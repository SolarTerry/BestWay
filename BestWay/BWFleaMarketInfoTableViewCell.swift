//
//  BWFleaMarketInfoTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/17.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit

class BWFleaMarketInfoTableViewCell: UITableViewCell {
    // MARK: - 标题label
    @IBOutlet weak var titleLabel: UILabel!
    // MARK: - 标题label高度
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    // MARK: - 价格label
    @IBOutlet weak var priceLabel: UILabel!
    // MARK: - 商品描述label
    @IBOutlet weak var descriptionLabel: UILabel!
    // MARK: - 商品描述label高度
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    // MARK: - 用户头像view
    @IBOutlet weak var userLogoImageView: UIImageView!
    // MARK: - 用户名label
    @IBOutlet weak var usernameLabel: UILabel!
    // MARK: - 发布时间label
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reloadData(title: String, price: String, description: String, userLogo: UIImage, username: String, time: String) {
        // 标题
        self.titleLabel.text = title
        // 使UILabel根据文字内容自适应高度
        var titleLabelSize = CGRect()
        titleLabelSize = labelSizeToFit(label: self.titleLabel, text: title, font: self.titleLabel.font)
        self.titleLabelHeight.constant = titleLabelSize.height
        
        // 价格
        self.priceLabel.text = "价格：\(price)元"
        
        // 商品描述
        self.descriptionLabel.text = description
        var descriptionLabelSize = CGRect()
        descriptionLabelSize = labelSizeToFit(label: self.descriptionLabel, text: description, font: self.descriptionLabel.font)
        self.descriptionLabelHeight.constant = descriptionLabelSize.height
        
        // 用户头像
        self.userLogoImageView.image = userLogo
        
        // 用户名
        self.usernameLabel.text = username
        
        // 发布时间
        self.timeLabel.text = time
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - 使UILabel根据文字内容自适应高度
    func labelSizeToFit(label: UILabel, text: String, font: UIFont) -> CGRect {
        // 使UILabel里的文字换行
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.numberOfLines = 0
        let labelText: NSString = text as NSString
        let attributes = [NSFontAttributeName: font]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let labelSize = labelText.boundingRect(with: CGSize(width: SCREEN_WIDTH, height: 0), options: options, attributes: attributes, context: nil)
        print("labelSize.height:\(labelSize.height)")
        return labelSize
    }
    
}
