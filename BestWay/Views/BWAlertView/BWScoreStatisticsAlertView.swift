//
//  BWScoreStatisticsAlertView.swift
//  BestWay
//
//  Created by solar on 17/5/20.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
// 成绩统计弹窗
class BWScoreStatisticsAlertView: UIViewController {
    // 弹窗背景透明度
    let kBakcgroundTansperancy: CGFloat = 0.7
    // 弹窗底部和内容底部的间距
    let kHeightMargin: CGFloat = 15.0
    // 弹窗顶部和内容顶部的间距
    let KTopMargin: CGFloat = 20.0
    // 弹窗两边和内容两变的间距、两个按钮的间距
    let kWidthMargin: CGFloat = 10.0
    //
    let kAnimatedViewHeight: CGFloat = 70.0
    // 弹窗高度
    let kMaxHeight: CGFloat = 600.0
    // 内容宽度
    var kContentWidth: CGFloat = 300.0
    // 按钮高度
    let kButtonHeight: CGFloat = 35.0
    //
    var textViewHeight: CGFloat = 90.0
    // 标题高度
    let kTitleHeight:CGFloat = 30.0
    // 内容view
    var contentView = UIView()
    // 标题label
    var titleLabel: UILabel = UILabel()
    // 获得总学分label
    var creditLabel = UILabel()
    // 加权平均分label
    var scoreLabel = UILabel()
    // 绩点label
    var GPALabel = UILabel()
    // 按钮组
    var buttons: [UIButton] = []
    // 强引用自己
    var strongSelf:BWScoreStatisticsAlertView?
    var userAction:((_ button: UIButton) -> Void)? = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.7)
        self.view.addSubview(contentView)
        
        //强引用 不然按钮点击不能执行
        strongSelf = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化内容view
    func setupContentView() {
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(titleLabel)
        contentView.addSubview(creditLabel)
        contentView.backgroundColor = UIColor.colorFromRGB(0xFFFFFF)
        contentView.layer.borderColor = UIColor.colorFromRGB(0xCCCCCC).cgColor
        view.addSubview(contentView)
    }
    
    // MARK: - 初始化标题label
    func setupTitleLabel() {
        titleLabel.text = ""
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica", size:25)
        titleLabel.textColor = UIColor.colorFromRGB(0x575757)
    }
    
    // MARK: - 初始化label
    func setupLabel(_ label: UILabel) {
        label.layer.borderColor = UIColor.colorFromRGB(0x575757).cgColor
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size:16)
        label.textColor = UIColor.colorFromRGB(0x797979)
    }
    
    //MARK: - 布局
    func resizeAndRelayout() {
        let mainScreenBounds = UIScreen.main.bounds
        self.view.frame.size = mainScreenBounds.size
        let x: CGFloat = kWidthMargin
        var y: CGFloat = KTopMargin
        let width: CGFloat = kContentWidth - (kWidthMargin * 2)
        let placeholderString = "" as NSString
        let placeholderRect = placeholderString.boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : creditLabel.font!], context: nil)
        
        // 标题
        if self.titleLabel.text != nil {
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: kTitleHeight)
            contentView.addSubview(titleLabel)
            y += kTitleHeight + kHeightMargin
        }
        
        // 获得学分
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        creditLabel.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(creditLabel)
        y += textViewHeight + kHeightMargin
        
        // 加权平均分
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        scoreLabel.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(scoreLabel)
        y += textViewHeight + kHeightMargin
        
        // 绩点
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        GPALabel.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(GPALabel)
        y += textViewHeight + kHeightMargin
        
        // MARK: - 按钮组
        var buttonRect:[CGRect] = []
        for button in buttons {
            let string = button.title(for: UIControlState.normal)! as NSString
            buttonRect.append(string.boundingRect(with: CGSize(width: width, height:0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSFontAttributeName:button.titleLabel!.font], context:nil))
        }
        
        var totalWidth: CGFloat = 0.0
        if buttons.count == 2 {
            totalWidth = buttonRect[0].size.width + buttonRect[1].size.width + kWidthMargin + 40.0
        }
        else{
            totalWidth = buttonRect[0].size.width + 20.0
        }
        y += kHeightMargin
        var buttonX = (kContentWidth - totalWidth ) / 2.0
        for i in 0 ..< buttons.count {
            
            buttons[i].frame = CGRect(x: buttonX, y: y, width: buttonRect[i].size.width + 20.0, height: buttonRect[i].size.height + 10.0)
            buttonX = buttons[i].frame.origin.x + kWidthMargin + buttonRect[i].size.width + 20.0
            buttons[i].layer.cornerRadius = 5.0
            self.contentView.addSubview(buttons[i])
            
        }
        y += kHeightMargin + buttonRect[0].size.height + 10.0
        if y > kMaxHeight {
            let diff = y - kMaxHeight
            let sFrame = creditLabel.frame
            creditLabel.frame = CGRect(x: sFrame.origin.x, y: sFrame.origin.y, width: sFrame.width, height: sFrame.height - diff)
            
            for button in buttons {
                let bFrame = button.frame
                button.frame = CGRect(x: bFrame.origin.x, y: bFrame.origin.y - diff, width: bFrame.width, height: bFrame.height)
            }
            
            y = kMaxHeight
        }
        
        contentView.frame = CGRect(x: (mainScreenBounds.size.width - kContentWidth) / 2.0, y: (mainScreenBounds.size.height - y) / 2.0, width: kContentWidth, height: y)
        contentView.clipsToBounds = true
        
        // MARK: - 进入时的动画
        contentView.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BWScoreStatisticsAlertView {
    func showAlert(_ credit: String, score: String, GPA: String, action:@escaping((_ OtherButton: UIButton) -> Void)) {
        userAction = action
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        
        self.setupContentView()
        self.setupTitleLabel()
        self.setupLabel(creditLabel)
        self.setupLabel(scoreLabel)
        self.setupLabel(GPALabel)
        
        self.titleLabel.text = "统计"
        self.creditLabel.text = "获得学分：\(credit)"
        self.scoreLabel.text = "加权平均分：\(score)"
        self.GPALabel.text = "绩点：\(GPA)"
        
        buttons = []
        let OKbutton = UIButton(type: UIButtonType.custom)
        OKbutton.setTitle("确定", for: UIControlState.normal)
        OKbutton.backgroundColor = MAIN_COLOR
        OKbutton.addTarget(self, action: #selector(doOK(_:)), for: .touchUpInside)
        buttons.append(OKbutton)
        resizeAndRelayout()
    }
    
    func doOK(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 0.0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
            
        }) { (Bool) -> Void in
            self.view.removeFromSuperview()
            self.cleanUpAlert()
            self.strongSelf = nil
        }
    }
    
    // MARK: - 关闭alert方法
    func cleanUpAlert() {
        self.contentView.removeFromSuperview()
        self.contentView = UIView()
    }
}
