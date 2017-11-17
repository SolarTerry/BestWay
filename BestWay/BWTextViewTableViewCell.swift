//
//  BWTextViewTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/4.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 多行文本输入框cell
class BWTextViewTableViewCell: UITableViewCell, UITextViewDelegate {
    // MARK: - 多行文本输入框
    var textView: UITextView!
    // MARK: - 字数label
    var countingLabel: UILabel!
    // MARK: - 字数
    var textNum = 0
    // MARK: - 最大输入字数
    let MAX_TEXT_NUM = 110
    
    // MARK: - 初始化方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView = UITextView(frame: CGRect.null)
        // 设置字体颜色
        textView.textColor = UIColor.black
        // 设置字体和大小
        textView.font = UIFont.systemFont(ofSize: 15)
        // 允许滚动
        textView.isScrollEnabled = true
        // 设置代理
        textView.delegate = self
        
        countingLabel = UILabel(frame: CGRect.null)
        countingLabel.text = "\(textNum)\\\(MAX_TEXT_NUM)"
        countingLabel.textColor = UIColor.black
        countingLabel.font = UIFont.systemFont(ofSize: 10)
        countingLabel.textAlignment = .right
        
        addSubview(textView)
        addSubview(countingLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置大小
        textView.frame = CGRect(x: 10, y: 1, width: bounds.size.width - 15, height: bounds.size.height - 10)
        countingLabel.frame = CGRect(x: 0, y: bounds.size.height - 10, width: bounds.size.width - 5, height: 10)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - 查找所在的ViewController
    func responderViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    // MARK: - 输入框限制输入
    func textViewDidChange(_ textView: UITextView) {
        // 获取已输出字数与正输入字数
        let markedRange = textView.markedTextRange
        
        // 获取高亮部分，如果有联想词则可以解包
        if let markedRange = markedRange {
            let position = textView.position(from: markedRange.start, offset: 0)
            if position != nil {
                return
            }
        }
        
        let textContent = textView.text
        let textNum = textContent?.characters.count
        
        // 截取110个字
        if textNum! > MAX_TEXT_NUM {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: MAX_TEXT_NUM)
            let str = textContent?.substring(to: index!)
            textView.text = str
            let alertController = UIAlertController.alertControllerWithTitle("已超出110个字", msg: "将截取前110个字")
            self.responderViewController()?.present(alertController, animated: true, completion: nil)
        }
        
        // 计算个数
        self.textNum = textView.text.characters.count
        self.countingLabel.text = "\(self.textNum)\\\(MAX_TEXT_NUM)"
    }
}
