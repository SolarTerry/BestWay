//
//  BWTextFieldTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/4/22.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 单行文本输入框
class BWTextFieldTableViewCell: UITableViewCell,UITextFieldDelegate {
    // MARK: - 可编辑label
    var textFieldLabel: UITextField!
    
    // MARK: - 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化可编辑label
        textFieldLabel = UITextField(frame: CGRect.null)
        textFieldLabel.textColor = UIColor.black
        textFieldLabel.font = UIFont.systemFont(ofSize: 15)
        
        // 设置代理
        textFieldLabel.delegate = self
        
        addSubview(textFieldLabel)
        
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        textFieldLabel.frame = CGRect(x: 15, y: 0, width: bounds.size.width - 15, height: bounds.size.height)
    }
    
    // MARK: - 键盘回车
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldLabel.resignFirstResponder()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
