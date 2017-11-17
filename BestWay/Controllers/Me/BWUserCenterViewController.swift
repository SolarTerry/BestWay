//
//  BWUserCenterViewController.swift
//  BestWay
//
//  Created by solar on 2017/10/15.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class BWUserCenterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 头像背景图片高度
    let topImageHeight = CGFloat(250)
    
    // MARK: - 头像背景图片
    var topImageView: UIImageView!
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 用户头像view
    var userLogoView: UIImageView!
    
    // MARK: - 用户头像
    var userLogo: UIImage!
    
    // MARK: - 用户头像
    let USER_LOGO_TAG = 1
    
    // MARK: - 用户昵称输入框
    var nickNameField:UITextField?
    
    // MARK: - 昵称Tag
    let NICK_NAME_TAG = 2
    
    // MARK: - 用户信息
    var user:BWUser?
    
    // MARK: - 点击手势
    var tapGestureRecognizer:UITapGestureRecognizer?
    
    // MARK: - 自定义导航栏
    var customNavBar: UIView!
    
    // MARK: - 自定义导航栏标题
    var customTitleLabel: UILabel!
    
    // MARK: - 当导航栏透明的时候的标题
    var viewTitleLabel: UILabel!
    
    // MARK: - 用户信息
    var info: [String]!
    
    // MARK: - 左侧图标集合
    let infoIconList = ["cell-icon-name",
                        "cell-icon-id",
                        "cell-icon-academy",
                        "cell-icon-major",
                        "cell-icon-phone",
                        "cell-icon-email"
    ]
    
    // MARK: - Cell名称集合
    let infoCellNameList = ["姓名：",
                            "学号：",
                            "学院：",
                            "专业：",
                            "电话：",
                            "邮箱："
    ]
    
    // MARK: - 设置图标集合
    let settingIconList = ["cell-icon-setting",
                           "cell-icon-setting"
    ]
    
    // MARK: - 设置cell名称集合
    let settingCellNameList = ["我的失物招领",
                               "我的二手市场"
    ]
    
    // MARK: - 设置图标集合
    let settingIcon = "cell-icon-setting"
    
    // MARK: - 主storyboard
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        info = ["hhhhh", "1401030090", "信息技术学院", "软件工程", "13798973819", "hhh@hh.com"]

        self.automaticallyAdjustsScrollViewInsets = false
        
        // MARK: - 头像背景图片
        self.topImageView = UIImageView(frame: CGRect(x: 0, y: -topImageHeight, width: view.bounds.width, height: topImageHeight))
        self.topImageView.image = UIImage(named: "bg")
        self.topImageView.contentMode = .scaleAspectFill
        self.topImageView.clipsToBounds = true
        
        // MARK: - tableView
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 50), style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(topImageHeight, 0, 0, 0)
        self.tableView.addSubview(self.topImageView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        
        // MARK: - 用户头像
        self.userLogoView = UIImageView(frame: CGRect(x: SCREEN_WIDTH / 2 - 50, y: topImageHeight / 2 - 50, width: 100, height: 100))
        self.userLogoView.layer.cornerRadius = userLogoView.frame.size.width / 2
        self.userLogoView.layer.masksToBounds = true
        self.userLogoView.image = userLogo
        self.topImageView.addSubview(self.userLogoView)
        
        // MARK: - 用户名label
        self.nickNameField = UITextField(frame: CGRect(x: 0, y: topImageHeight / 2 + 65, width: SCREEN_WIDTH, height: 15))
        self.nickNameField?.tag = NICK_NAME_TAG
        self.nickNameField?.textAlignment = .center
        self.nickNameField?.textColor = UIColor.white
        nickNameField?.text = "点击修改昵称"
        self.topImageView.addSubview(self.nickNameField!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 144
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // section标题view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        // 信息标题label
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: SCREEN_WIDTH, height: 20))
        switch section {
        // 基本信息section标题
        case 0:
            initLabel(label: label, text: "基本信息")
            view.addSubview(label)
            return view
        // 更多信息section标题
        case 1:
            initLabel(label: label, text: "更多信息")
            view.addSubview(label)
            return view
        // 其他section标题
        case 2:
            initLabel(label: label, text: "其他")
            view.addSubview(label)
            return view
        default:
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        switch indexPath.section {
        case 0:
            let cellIdentifier = "cell"
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
            cell?.selectionStyle = .none
            // cell左边的图标
            let leftImageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 44 - 12 * 2, height: 44 - 12 * 2))
            leftImageView.image = UIImage(named: self.infoIconList[indexPath.row])
            
            // 左侧Label
            let leftLabel = UILabel(frame: CGRect(x: Int(leftImageView.frame.maxX + leftImageView.frame.size.width), y: 0, width: 45, height: 44))
            leftLabel.adjustsFontSizeToFitWidth = true
            leftLabel.text = infoCellNameList[indexPath.row]
            
            // 用户信息显示Label
            let infoLabel = UILabel(frame: CGRect(x: leftLabel.frame.maxX + 10, y: 0, width: 125, height: 44))
            infoLabel.adjustsFontSizeToFitWidth = true
            infoLabel.textColor = UIColor.darkGray
            infoLabel.text = info[indexPath.row]
            
            cell?.addSubview(infoLabel)
            cell?.addSubview(leftLabel)
            cell?.addSubview(leftImageView)
            
            return cell!
        case 1:
            let cellIdentifier = "cell"
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
            // cell左边的图标
            let leftImageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 44 - 12 * 2, height: 44 - 12 * 2))
            leftImageView.image = UIImage(named: settingIconList[indexPath.row])
            
            // 左侧Label
            let leftLabel = UILabel(frame: CGRect(x: Int(leftImageView.frame.maxX + leftImageView.frame.size.width), y: 0, width: Int(SCREEN_WIDTH), height: 44))
            leftLabel.adjustsFontSizeToFitWidth = true
            leftLabel.text = settingCellNameList[indexPath.row]
            
            // 下方图片Label
            let imageLabel = UILabel(frame: CGRect(x: Int(leftImageView.frame.maxX + leftImageView.frame.size.width), y: Int(leftLabel.frame.size.height + 10), width: Int(SCREEN_WIDTH - 10), height: 80))
            let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            let imageView2 = UIImageView(frame: CGRect(x: 90, y: 0, width: 80, height: 80))
            let imageView3 = UIImageView(frame: CGRect(x: 180, y: 0, width: 80, height: 80))
            imageView1.image = UIImage.init(named: "delete")
            imageView2.image = UIImage.init(named: "bg")
            imageView3.image = UIImage.init(named: "bg")
            imageLabel.addSubview(imageView1)
            imageLabel.addSubview(imageView2)
            imageLabel.addSubview(imageView3)
            
            cell?.addSubview(leftImageView)
            cell?.addSubview(leftLabel)
            cell?.addSubview(imageLabel)
            
            cell?.accessoryType = .disclosureIndicator
            
            return cell!
        case 2:
            let cellIdentifier = "cell"
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
            cell?.selectionStyle = .none
            // cell左边的图标
            let leftImageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 44 - 12 * 2, height: 44 - 12 * 2))
            leftImageView.image = UIImage(named: self.settingIcon)
            
            // 左侧Label
            let leftLabel = UILabel(frame: CGRect(x: Int(leftImageView.frame.maxX + leftImageView.frame.size.width), y: 0, width: 45, height: 44))
            leftLabel.adjustsFontSizeToFitWidth = true
            leftLabel.text = "设置"
            
            cell?.accessoryType = .disclosureIndicator
            
            cell?.addSubview(leftLabel)
            cell?.addSubview(leftImageView)
            
            return cell!
        default:
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                let vc = storyBoard.instantiateViewController(withIdentifier: "singleLostAndFoundViewController")
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = storyBoard.instantiateViewController(withIdentifier: "singleLostAndFoundViewController")
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                return
            }
        case 2:
            let vc = storyBoard.instantiateViewController(withIdentifier: "settingTableViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = scrollView.contentOffset.y
        // 根据偏移量改变alpha的值
        self.navigationController?.navigationBar.alpha = (offY + 64) / (self.topImageHeight - 64) + 1
        // 设置图片的高度 和 Y 值
        if offY < -self.topImageHeight {
            self.topImageView.frame.origin.y = offY
            self.topImageView.frame.size.height = -offY
        }
        // 改变导航栏返回按钮的图片和标题颜色
        if offY >= -64 {
            self.navigationItem.title = "个人资料"
        }
    }
    
    // MARK: - 标题label初始化
    func initLabel(label: UILabel, text: String) {
        label.text = text
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
    }
    
    // MARK: - 获取用户基本信息
    func retrieveUserInfo() {
        let requestUtil = BWRequestUtil.shareInstance
        let userData = UserDefaults.standard.data(forKey: "BWUser")
        
        // 尝试从本地获取用户信息
        if userData != nil {
            user = (NSKeyedUnarchiver.unarchiveObject(with: userData!) as! BWUser)
            return
        }
        requestUtil.sendRequestResponseJSON(BWApiurl.GET_USER_INFO, method: .post, parameters: [:]) { response in
            SVProgressHUD.show(withStatus: "数据加载中...")
            var data = JSON(data: response.data!)
            
            // 返回数据为空
            if data == JSON.null {
                SVProgressHUD.showError(withStatus: "服务器异常！")
                return
            }
            
            var info = data["data"]
            
            // 返回的Message信息
            let message = data["message"].stringValue
            
            // 返回的Code
            let code = data["code"].intValue
            
            switch code {
            case 0:
                // 解析出JSON中信息
                let id = info["id"].intValue
                let realName = info["realName"].stringValue
                let password = info["password"].stringValue
                let nickname = info["nickname"].stringValue
                let college = info["college"].stringValue
                let email = info["email"].stringValue
                let grade = info["grade"].stringValue
                let username = info["username"].stringValue
                let major = info["major"].stringValue
                let sex = info["sex"].intValue
                let phone = info["phone"].stringValue
                let birthday = info["birthday"].stringValue
                let createTime = info["createTime"].stringValue
                
                // 写入User Model
                self.user = BWUser(id: id, username: username, password: password, nickname: nickname, college: college, major: major, grade: grade, birthday: birthday, phone: phone, email: email, realName: realName, sex: sex, createTime: createTime)
                
                
                // 将User对象序列化为NSData存进NSUserDefaults
                let userdata:Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                UserDefaults.standard.set(userdata, forKey: "BWUser")
                SVProgressHUD.showSuccess(withStatus: "获取成功")
            default:
                SVProgressHUD.showError(withStatus: message)
            }
            
        }
        
    }

}
