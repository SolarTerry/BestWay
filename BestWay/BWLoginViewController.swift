//
//  ViewController.swift
//  BestWay
//
//  Created by 万志强 on 16/10/30.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
// 登录页面控制器
class BWLoginViewController: UIViewController {
    
    // MARK: - 标签字体大小
    var labelFontSize:CGFloat = 15
    
    // MARK: - 用户名Tag
    var USERNAME_TAG = 1
    
    // MARK: - 密码Tag
    var PASSWORD_TAG = 2
    
    // MARK: - 登录按钮
    var LOGIN_BUTTON_TAG = 3
    
    // MARK: - 无法登录按钮Tag
    var NOLOGIN_BUTTON_TAG = 4
    
    // MARK: - 用户名输入框
    var usernameField = UITextField()
    
    // MARK: - 密码输入框
    var passwordField = UITextField()
    
    // MARK: - 用户头像View
    var logoView = UIImageView()
    
    // MARK: - 无法登陆提示框View
    var noLoginAlertView = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化界面
        initView()
    }
    
    
    // MARK: - 初始化窗体
    func initView() {
        // 输入框容器View
        let textFieldView = UIView(frame: CGRect(x: 0, y: 180, width: self.view.frame.size.width, height: 90))
        textFieldView.layer.masksToBounds = true
        textFieldView.backgroundColor = UIColor.white
        
        // 输入框Frame
        let frame = textFieldView.frame
        
        // 输入框分割线
        let separateLine = UIView(frame: CGRect(x: 0, y: frame.size.height / 2, width: frame.size.width, height: 0.6))
        separateLine.backgroundColor = UIColor(red: 99/255, green: 185/255, blue: 255/255, alpha: 0.3)
        
        // MARK: - 用户名输入框
        usernameField = UITextField(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 2))
        usernameField.clearButtonMode = .whileEditing
        usernameField.placeholder = "用户名"
        usernameField.textAlignment = .center
        usernameField.delegate = self
        usernameField.tag = USERNAME_TAG
        
        // MARK: - 密码输入框
        passwordField = UITextField(frame: CGRect(x: 0, y: frame.size.height / 2, width: frame.size.width, height: frame.size.height / 2))
        passwordField.returnKeyType = .go
        passwordField.isSecureTextEntry = true
        passwordField.clearButtonMode = .whileEditing
        passwordField.placeholder = "密码"
        passwordField.textAlignment = .center
        passwordField.delegate = self
        passwordField.tag = PASSWORD_TAG
    
        // MARK: - 登录按钮
        let loginBtn = UIButton(frame: CGRect(x: 20, y: frame.maxY + 30, width: frame.size.width - 40, height: 50))
        loginBtn.layer.cornerRadius = 5
        loginBtn.backgroundColor = UIColor(red: 99/255, green: 185/255, blue: 255/255, alpha: 1)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.tag = LOGIN_BUTTON_TAG
        // 按钮点击时的高亮变色
        loginBtn.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6), for:.highlighted )
        loginBtn.addTarget(self, action: #selector(BWLoginViewController.buttonClicked), for: .touchUpInside)
        
        // MARK: - 无法登陆按钮
        let noLoginBtn = UIButton(frame: CGRect(x: 20, y: self.view.frame.maxY - 40, width: 100, height: 30))
        noLoginBtn.setTitleColor(UIColor(red: 99/255, green: 150/255, blue: 255/255, alpha: 1), for: .normal)
        noLoginBtn.setTitleColor(UIColor(red: 99/255, green: 150/255, blue: 255/255, alpha: 0.6), for: .highlighted)
        noLoginBtn.tag = NOLOGIN_BUTTON_TAG
        noLoginBtn.setTitle("无法登录？", for: .normal)
        noLoginBtn.titleLabel?.font = UIFont(name: "Arial", size: labelFontSize)
        noLoginBtn.addTarget(self, action: #selector(BWLoginViewController.buttonClicked), for: .touchUpInside)

        noLoginAlertView = UIAlertController(title: "PigVillage Studio\n", message: "如确认账号密码无误，请联系我们。\n\nEmail:pigvillage@126.com\nQQ:531012201", preferredStyle: .alert)
        noLoginAlertView.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        
        // MARK: - 关于我们按钮
        let aboutUsBtn = UIButton(frame: CGRect(x: self.view.frame.size.width - 120, y: self.view.frame.maxY - 40, width: 100, height: 30))
        aboutUsBtn.setTitleColor(UIColor(red: 99/255, green: 150/255, blue: 255/255, alpha: 1), for: .normal)
        aboutUsBtn.setTitleColor(UIColor(red: 99/255, green: 150/255, blue: 255/255, alpha: 0.6), for: .highlighted)
        aboutUsBtn.titleLabel?.font = UIFont(name: "Arial", size: labelFontSize)
        aboutUsBtn.setTitle("关于我们", for: .normal)
        
        // MARK: - 用户头像View
        logoView = UIImageView(frame: CGRect(x: (self.view.frame.size.width - 116) / 2, y: frame.minY - 116 - 20, width: 116, height: 116))
        logoView.image = UIImage(named: "user-default-logo")
        logoView.layer.masksToBounds = true
        logoView.layer.cornerRadius = 58

        // 添加子视图
        textFieldView.addSubview(usernameField)
        textFieldView.addSubview(passwordField)
        textFieldView.addSubview(separateLine)
        
        self.view.addSubview(textFieldView)
        self.view.addSubview(loginBtn)
        self.view.addSubview(noLoginBtn)
        self.view.addSubview(aboutUsBtn)
        self.view.addSubview(logoView)
        
        
    }
    
    // MARK: - 按钮点击处理方法
    func buttonClicked(sender:UIButton) {
        switch sender.tag {
        case NOLOGIN_BUTTON_TAG:
            self.present(noLoginAlertView, animated: true, completion: nil)
        case LOGIN_BUTTON_TAG:
            SVProgressHUD.show(withStatus: "正在登录...")
            
            // 登录参数
            let parameters = ["username": self.usernameField.text!,"password": self.passwordField.text!]
            
            // 向服务端发送登录请求
            Alamofire.request(BWApiurl.LOGIN_CHECK, method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                let data = JSON(data: response.data!)
                
                // 返回数据为空
                if data == JSON.null {
                    SVProgressHUD.showError(withStatus: "服务器异常！")
                    return
                }
                
                let msg = data["message"].stringValue
                let code = data["code"].intValue
                if code == 0 {
                    UserDefaults.standard.set(self.usernameField.text, forKey: "username")
                    SVProgressHUD.showSuccess(withStatus: msg)
                    self.performSegue(withIdentifier: "login", sender: self)
                } else {
                    SVProgressHUD.showError(withStatus: msg)
                }
            })
        default:
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 实现BWLoginViewController的UITextField代理方法
extension BWLoginViewController:UITextFieldDelegate {
    
    // MARK: - 用户输入完账号后自动从七牛获取头像
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == USERNAME_TAG {
            
            // 构造用户的头像地址
            let userLogoUrl = BWApiurl.getUerImageUrl(textField.text!)

            Alamofire.request(userLogoUrl).responseData(completionHandler: { (response) in
                // 当 NSString(data: Response.data!, encoding: NSUTF8StringEncoding) 等于nil时，说明返回的数据是一个图片，然后继续执行设置头像的语句，如果不等于nil，说明返回的是{"error":"Document not found"},该图片不存在七牛空间中，则return
                if NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) != nil {
                    self.logoView.image = UIImage(named: "user-default-logo")
                    return
                }
                let image = UIImage(data: response.data!)
                self.logoView.image = image
            })
        }
    }
}

