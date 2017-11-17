//
//  BWExpressAddAlertView.swift
//  BestWay
//
//  Created by solar on 17/3/4.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

// 快递中心添加快递信息按钮点击后显示的弹窗
class BWExpressAddAlertView: UIViewController {
    
    /// 弹窗背景透明度
    let kBakcgroundTansperancy: CGFloat = 0.7
    /// 弹窗底部和内容底部的间距
    let kHeightMargin: CGFloat = 15.0
    /// 弹窗顶部和内容顶部的间距
    let KTopMargin: CGFloat = 20.0
    /// 弹窗两边和内容两变的间距、两个按钮的间距
    let kWidthMargin: CGFloat = 10.0
    ///
    let kAnimatedViewHeight: CGFloat = 70.0
    /// 弹窗高度
    let kMaxHeight: CGFloat = 600.0
    /// 内容宽度
    var kContentWidth: CGFloat = 300.0
    /// 按钮高度
    let kButtonHeight: CGFloat = 35.0
    ///
    var textViewHeight: CGFloat = 90.0
    /// 标题高度
    let kTitleHeight:CGFloat = 30.0
    /// 内容view
    var contentView = UIView()
    /// 标题label
    var titleLabel: UILabel = UILabel()
    /// 目标地址输入框
    var targetAddressTextField = UITextField()
    /// 订单备注输入框
    var noteTextField = UITextField()
    /// 佣金、费用输入框
    var bonusMoneyTextField = UITextField()
    /// 支付方式输入框
    var paymentWayDropBoxView: BWDropBoxView!
    /// 支付方式placeholder
    let defaultTitle = "请选择支付方式"
    /// 可选择的支付方式
    let choices = ["微信", "货到付款"]
    /// 过期时间输入框
    var closeTimeTextField = UITextField()
    /// 日期选择器
    var datePicker = UIDatePicker()
    /// 过期日期
    var closeTimeStr = ""
    /// 按钮组
    var buttons: [UIButton] = []
    /// 强引用自己
    var strongSelf:BWExpressAddAlertView?
    var userAction:((_ button: UIButton) -> Void)? = nil
    /// 快递点id
    var expressId:Int!
    /// 快递大小输入框
    var sizeDropBoxView: BWDropBoxView!
    /// 可选择快递大小
    let sizes = ["大件","中件","小件"]
    
    // MARK: - 初始化界面
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.7)
        self.view.addSubview(contentView)
        
        //强引用 不然按钮点击不能执行
        strongSelf = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化内容view
    func setupContentView() {
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(titleLabel)
        contentView.addSubview(targetAddressTextField)
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
    
    // MARK: - 初始化输入框
    func setupTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.colorFromRGB(0x575757).cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5.0
        textField.placeholder = ""
        textField.textAlignment = .center
        textField.font = UIFont(name: "Helvetica", size:16)
        textField.textColor = UIColor.colorFromRGB(0x797979)
    }
    
    
    //MARK: - 布局
    func resizeAndRelayout() {
        let mainScreenBounds = UIScreen.main.bounds
        self.view.frame.size = mainScreenBounds.size
        let x: CGFloat = kWidthMargin
        var y: CGFloat = KTopMargin
        let width: CGFloat = kContentWidth - (kWidthMargin * 2)
        let placeholderString = "" as NSString
        let placeholderRect = placeholderString.boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : targetAddressTextField.font!], context: nil)
        
        // MARK: - 标题
        if self.titleLabel.text != nil {
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: kTitleHeight)
            contentView.addSubview(titleLabel)
            y += kTitleHeight + kHeightMargin
        }
        
        // MARK: - 目标地址
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        targetAddressTextField.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(targetAddressTextField)
        y += textViewHeight + kHeightMargin
        
        // MARK: - 佣金
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        bonusMoneyTextField.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(bonusMoneyTextField)
        y += textViewHeight + kHeightMargin
        
        // MARK: - 备注
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        noteTextField.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(noteTextField)
        y += textViewHeight + kHeightMargin
        
        // MARK: - 过期时间
        closeTimeTextField.inputView = datePicker
        datePicker.locale = Locale(identifier: "zh_cn") as Locale
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.layer.backgroundColor = UIColor.white.cgColor
        datePicker.addTarget(self, action: #selector(getDate), for: UIControlEvents.valueChanged)
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        closeTimeTextField.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
        contentView.addSubview(closeTimeTextField)
        y += textViewHeight + kHeightMargin
        
        // MARK: - 支付方式
        textViewHeight = ceil(placeholderRect.size.height) + 10.0
        paymentWayDropBoxView = BWDropBoxView(parentVC: contentView, title: defaultTitle, items: choices, frame: CGRect(x: x, y: y, width: width, height: textViewHeight))
        paymentWayDropBoxView.isHightWhenShowList = true
        paymentWayDropBoxView.willShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("will show choices") }
            else { NSLog("will hide choices") }
        }
        paymentWayDropBoxView.didShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("did show choices") }
            else { NSLog("did hide choices") }
        }
        paymentWayDropBoxView.didSelectBoxItemHandler = { (row) in
            NSLog("selected No.\(row): \(self.paymentWayDropBoxView.currentTitle())")
        }
        contentView.addSubview(paymentWayDropBoxView)
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
            let sFrame = targetAddressTextField.frame
            targetAddressTextField.frame = CGRect(x: sFrame.origin.x, y: sFrame.origin.y, width: sFrame.width, height: sFrame.height - diff)
            
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
    
    // MARK: - 日期选择器选择事件处理
    func getDate(_ datePicker: UIDatePicker) {
        // MARK: - 提交到服务器的时间格式
        let postFormatter = DateFormatter()
        postFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.closeTimeStr = postFormatter.string(from: datePicker.date)
        // mark: - 客户端显示的时间格式
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        let dateStr = formatter.string(from: datePicker.date)
        self.closeTimeTextField.text = dateStr
    }
}

// MARK: - BWExpressAddAlertView扩展方法
extension BWExpressAddAlertView{
    
    //MARK: - alert 方法主体
    func showAlert(_ expressId:Int,action:@escaping ((_ OtherButton: UIButton) -> Void)) {
        
        userAction = action
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        
        self.setupContentView()
        self.setupTitleLabel()
        self.setupTextField(bonusMoneyTextField)
        self.setupTextField(targetAddressTextField)
        self.setupTextField(noteTextField)
        self.setupTextField(closeTimeTextField)
        
        self.expressId = expressId
        self.titleLabel.text = "创建我的订单"
        self.targetAddressTextField.placeholder = "请输入目标地址"
        self.bonusMoneyTextField.placeholder = "请输入代领费用(元)"
        self.bonusMoneyTextField.keyboardType = .numberPad
        self.noteTextField.placeholder = "备注(非必填)"
        self.closeTimeTextField.placeholder = "请选择时间"
        
        buttons = []
        let cancelButton: UIButton = UIButton()
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.backgroundColor = MAIN_COLOR
        cancelButton.isUserInteractionEnabled = true
        cancelButton.addTarget(self, action: #selector(BWExpressAddAlertView.doCancel), for: .touchUpInside)
        cancelButton.tag = 0
        buttons.append(cancelButton)
        
        let OKButton: UIButton = UIButton(type: UIButtonType.custom)
        OKButton.setTitle("确定", for: UIControlState.normal)
        OKButton.backgroundColor = MAIN_COLOR
        OKButton.addTarget(self, action: #selector(BWExpressAddAlertView.pressed), for: .touchUpInside)
        OKButton.tag = 1
        buttons.append(OKButton)

        resizeAndRelayout()
    }
    
    //MARK: - 取消按钮点击事件处理方法
    func doCancel(_ sender:UIButton){
        
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
    
    // MARK: - 确定按钮点击事件处理方法
    func pressed(_ sender: UIButton!) {
        if userAction !=  nil {
            userAction!(sender)
            if self.targetAddressTextField.text != "" && self.bonusMoneyTextField.text != "" && self.closeTimeTextField.text != "" && self.paymentWayDropBoxView.currentTitle() != "请选择支付方式" {
                
                SVProgressHUD.show(withStatus: "正在创建...")
                
                let userData = UserDefaults.standard.data(forKey: "BWUser")
                let user = NSKeyedUnarchiver.unarchiveObject(with: userData!) as! BWUser
                let masterUserId = user.username
                let expressSiteId = self.expressId as Int
                let targetAddress = self.targetAddressTextField.text!
                let bonusMoney = self.bonusMoneyTextField.text!
                let paymentWay:Int!
                switch self.paymentWayDropBoxView.currentTitle() {
                case "微信":
                    paymentWay = 0
                    break
                case "货到付款":
                    paymentWay = 1
                default:
                    return
                }
                let closeTime = self.closeTimeStr
                
                var parameters = ["masterUserId":masterUserId, "expressSiteId":expressSiteId, "targetAddress": targetAddress, "bonusMoney": bonusMoney, "paymentWay": paymentWay, "closeTime": closeTime] as [String : Any]
                if self.noteTextField.text != "" {
                    parameters = ["masterUserId":user.username, "expressSiteId":self.expressId, "targetAddress": self.targetAddressTextField.text!,"note": self.noteTextField.text!, "bonusMoney": self.bonusMoneyTextField.text!, "paymentWay": self.paymentWayDropBoxView.currentTitle(), "closeTime": self.closeTimeTextField.text!] as [String : Any]
                }
                
                Alamofire.request(BWApiurl.CREAT_NEW_ORDER, method: .post, parameters: parameters).responseJSON(completionHandler:{
                    (response) in
                    let data = JSON(data: response.data!)
                    if data == JSON.null {
                        SVProgressHUD.showError(withStatus: "服务器异常！")
                        return
                    }
                    let msg = data["message"].stringValue
                    let code = data["code"].intValue
                    if code == 0 {
                        SVProgressHUD.showSuccess(withStatus: "创建成功！")
                    }else {
                        SVProgressHUD.showError(withStatus: "创建失败！")
                    }
                })
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    self.view.alpha = 0.0
                    self.contentView.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
                    
                }) { (Bool) -> Void in
                    
                    self.view.removeFromSuperview()
                    self.cleanUpAlert()
                    self.strongSelf = nil
                }
            }else {
                SVProgressHUD.showError(withStatus: "请填写完整信息！")
            }
            
        }
    }
    
    
}


