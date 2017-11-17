//
//  BWElectricityAlertView.swift
//  BestWay
//
//  Created by solar on 17/5/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
// 电费查询结果弹窗
class BWElectricityAlertView: UIViewController {
    
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
    // 宿舍房号label
    var dormitoryNumberLabel = UILabel()
    // 剩余电量label
    var residualElectricityLabel = UILabel()
    // 剩余电费label
    var residualChargeLabel = UILabel()
    // 按钮组
    var buttons: [UIButton] = []
    // 强引用自己
    var strongSelf:BWElectricityAlertView?
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 初始化内容view
    func setupContentView() {
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(titleLabel)
        contentView.addSubview(dormitoryNumberLabel)
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
        let placeholderRect = placeholderString.boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : dormitoryNumberLabel.font!], context: nil)
        
        // 标题
        if self.titleLabel.text != nil {
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: kTitleHeight)
            contentView.addSubview(titleLabel)
            y += kTitleHeight + kHeightMargin
        }
        
        // 宿舍房号
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        dormitoryNumberLabel.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(dormitoryNumberLabel)
        y += textViewHeight + kHeightMargin
        
        // 剩余电量
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        residualElectricityLabel.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(residualElectricityLabel)
        y += textViewHeight + kHeightMargin
        
        // 剩余电费
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        residualChargeLabel.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(residualChargeLabel)
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
            let sFrame = dormitoryNumberLabel.frame
            dormitoryNumberLabel.frame = CGRect(x: sFrame.origin.x, y: sFrame.origin.y, width: sFrame.width, height: sFrame.height - diff)
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BWElectricityAlertView {
    func showAlert(_ dormitoryNumber: String, residualElectricity: String, residualCharge: String, action:@escaping((_ OtherButton: UIButton) -> Void)) {
        userAction = action
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        
        self.setupContentView()
        self.setupTitleLabel()
        self.setupLabel(dormitoryNumberLabel)
        self.setupLabel(residualElectricityLabel)
        self.setupLabel(residualChargeLabel)
        
        self.titleLabel.text = "统计"
        self.dormitoryNumberLabel.text = "宿舍房号：\(dormitoryNumber)"
        self.residualElectricityLabel.text = "剩余电量：\(residualElectricity)"
        self.residualChargeLabel.text = "剩余电费：\(residualCharge)"
        
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
