//
//  BWElectricityViewController.swift
//  BestWay
//
//  Created by solar on 17/5/25.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD
// 电费查询页面控制器
class BWElectricityViewController: UIViewController {
    
    // MARK: - 返回按钮
    var backButton: UIButton!
    
    // MARK: - 返回按钮tag
    let BACK_BUTTON_TAG = 1
    
    // MARK: - 宿舍帐号
    var dormitoryAccount: String!
    
    // MARK: - 宿舍帐号输入框
    var dormitoryAccountTextField: UITextField!
    
    // MARK: - 密码
    var password: String!
    
    // MARK: - 密码输入框
    var passwordTextField: UITextField!
    
    // MARK: - 宿舍房号
    var dormitoryNumber: String!
    
    // MARK: - 剩余电量
    var residualElectricity: String!
    
    // MARK: - 剩余电费
    var residualElectricityCharge: String!
    
    // MARK: - 查询按钮
    var searchButton: UIButton!
    
    // MARK: - 查询按钮tag
    let SEARCH_BUTTON_TAG = 2
    
    override func viewWillAppear(_ animated: Bool) {
        // 隐藏底部导航栏
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 模拟数据
        self.dormitoryAccount = "000000001234"
        self.password = "123456"
        self.dormitoryNumber = "海华苑11栋B418"
        self.residualElectricity = "0.0"
        self.residualElectricityCharge = "0.0"
        // 初始化界面
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 界面初始化方法
    func initView() {
        // 背景图
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        backgroundImageView.image = UIImage(named: "bg")
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        // 背景图的模糊滤镜
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.frame
        backgroundImageView.addSubview(blurView)
        self.view.addSubview(backgroundImageView)
        
        // 返回按钮
        self.backButton = UIButton(frame: CGRect(x: 0, y: 30, width: 30, height: 30))
        self.backButton.tag = BACK_BUTTON_TAG
        self.backButton.setImage(UIImage.init(named: "back_gray"), for: .normal)
        self.backButton.setBackgroundImage(UIImage.init(named: "back_blue"), for: .normal)
        self.backButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButton)
        
        // 宿舍账号输入框
        self.dormitoryAccountTextField = UITextField(frame: CGRect(x: 50, y: SCREEN_WIDTH / 3, width: SCREEN_WIDTH - 100, height: 40))
        setupTextField(self.dormitoryAccountTextField, title: "请填写宿舍帐号", roundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight])
        self.dormitoryAccountTextField.keyboardType = .numberPad
        self.view.addSubview(self.dormitoryAccountTextField)
        
        // 宿舍密码输入框
        self.passwordTextField = UITextField(frame: CGRect(x: 50, y: SCREEN_WIDTH / 3 + 40 + 10, width: SCREEN_WIDTH - 100, height: 40))
        setupTextField(self.passwordTextField, title: "请填写宿舍密码", roundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight])
        self.passwordTextField.isSecureTextEntry = true
        self.view.addSubview(self.passwordTextField)
        
        // 查询按钮
        self.searchButton = UIButton(frame: CGRect(x: SCREEN_WIDTH / 2 - 50, y: self.passwordTextField.frame.origin.y + self.passwordTextField.frame.size.height + 10, width: 100, height: 40))
        setupButton(self.searchButton, tag: SEARCH_BUTTON_TAG, title: "电费查询", color: MAIN_COLOR)
        self.view.addSubview(self.searchButton)
        
    }
    
    // MARK: - 初始化输入框
    func setupTextField(_ sender: UITextField, title: String, roundingCorners: UIRectCorner) {
        // 部分圆角
        let maskPath = UIBezierPath(roundedRect: sender.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: 12, height: 12))
        
        // 边框
        let borderLayer = CAShapeLayer()
        borderLayer.frame = sender.bounds
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = UIColor.darkGray.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        // 将边框添加进layer
        let maskLayer = CAShapeLayer()
        maskLayer.frame = sender.bounds
        maskLayer.path = maskPath.cgPath
        sender.layer.mask = maskLayer
        sender.layer.addSublayer(borderLayer)
        
        // 占位字符串
        sender.placeholder = title
        // 字符居中
        sender.textAlignment = .center
    }
    
    // MARK: - 初始化按钮
    func setupButton(_ sender: UIButton, tag: Int, title: String, color: UIColor) {
        // 圆角
        sender.layer.cornerRadius = 12
        // 设置按钮tag
        sender.tag = tag
        // 设置按钮标题
        sender.setTitle(title, for: UIControlState.normal)
        // 设置按钮标题颜色
        sender.setTitleColor(UIColor.white, for: UIControlState.normal)
        // 设置按钮背景色
        sender.backgroundColor = color
        sender.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
    }
    
    // MARK: - 按钮点击监听方法
    func buttonClicked(_ sender: UIButton) {
        switch sender.tag {
        // 返回按钮
        case BACK_BUTTON_TAG:
            // 返回上一页面
            self.navigationController?.popViewController(animated: true)
        // 查询按钮
        case SEARCH_BUTTON_TAG:
            // 判断信息输入是否为空
            if (self.dormitoryAccountTextField.text?.isEmpty)! || (self.passwordTextField.text?.isEmpty)! {
                SVProgressHUD.showError(withStatus: "请填写完整信息！")
                return
            }else {
                SVProgressHUD.show(withStatus: "正在查询...")
                // 判断信息输入是否有误
                if self.dormitoryAccountTextField.text! == self.dormitoryAccount! && self.passwordTextField.text! == self.password! {
                    SVProgressHUD.dismiss()
                    // 弹窗
                    BWElectricityAlertView().showAlert(dormitoryNumber, residualElectricity: residualElectricity, residualCharge: residualElectricityCharge, action: { (otherButton) in
                    })
                }else {
                    SVProgressHUD.showError(withStatus: "账号密码不匹配")
                }
            }
        default:
            return
        }
    }

}
