//
//  BWUserViewController.swift
//  BestWay
//
//  Created by solar on 17/5/9.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD
// 用户个人资料展示控制器
class BWUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 顶部图片高度
    let topImageHeight = CGFloat(250)
    
    // MARK: - 顶部图片
    var topImageView: UIImageView!
    
    // MARK: - 自定义导航栏
    var customNavBar: UIView!
    
    // MARK: - 自定义返回按钮
    var customBackBtn: UIButton!
    
    // MARK: - 自定义返回按钮tag
    let CUSTOM_BACK_BTN_TAG = 1
    
    // MARK: - 当导航栏透明的时候的返回按钮
    var viewBackBtn: UIButton!
    
    // MARK: - 当导航栏透明的时候的返回按钮tag
    let VIEW_BACK_BTN_TAG = 1
    
    // MARK: - 自定义导航栏标题
    var customTitleLabel: UILabel!
    
    // MARK: - 当导航栏透明的时候的标题
    var viewTitleLabel: UILabel!
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 用户名
    var username: String!
    
    // MARK: - 底部工具栏
    var toolBar: UIToolbar!
    
    // MARK: - 联系她／他按钮
    var contectButton: UIButton!
    
    // MARK: - 联系她／他按钮tag
    let CONTECT_BUTTON_TAG = 2
    
    // MARK: - 举报他／她按钮
    var reportButton: UIButton!
    
    // MARK: - 举报他／她按钮tag
    let REPORT_BUTTON_TAG = 3
    
    var toolbarItemsArray: [UIBarButtonItem]?
    
    // MARK: - 主storyboard
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - 用户头像view
    var userLogoView: UIImageView!
    
    // MARK: - 用户头像
    var userLogo: UIImage!
    
    // MARK: - 昵称
    var nicknameLabel: UILabel!
    
    // MARK: - 性别
    var sex: String!
    
    // MARK: - 学号
    var studentID: String!
    
    // MARK: - 学院
    var collage: String!
    
    // MARK: - 专业
    var major: String!
    
    // MARK: - 电话
    var phone: String!
    
    // MARK: - 邮箱
    var mail: String!
    
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
    
    var info: [String]!
    
    // MARK: - 设置图标集合
    let settingIconList = ["cell-icon-setting",
                           "cell-icon-setting",
                           ""
    ]
    
    // MARK: - 设置cell名称集合
    let settingCellNameList = ["他的失物招领",
                               "他的二手市场",
                               ""
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 这是模拟的数据啊！！
        info = [username, "1401030090", "信息技术学院", "软件工程", "13798973819", "hhh@hh.com"]
        self.studentID = info[1]

        self.automaticallyAdjustsScrollViewInsets = false
        
        // MARK: - 顶部图片
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
        
        // MARK: - 自定义导航栏
        self.customNavBar = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 64))
        self.view.addSubview(customNavBar)
        self.customNavBar.backgroundColor = UIColor.white
        self.customNavBar.alpha = 0.0
        
        // MARK: - 自定义返回按钮
        self.customBackBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 40, height: 44))
        self.customBackBtn.setImage(UIImage.init(named: "back_blue"), for: .normal)
        self.customBackBtn.tag = CUSTOM_BACK_BTN_TAG
        self.customBackBtn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.customNavBar.addSubview(self.customBackBtn)
        
        // MARK: - 当导航栏透明的时候的返回按钮
        self.viewBackBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 40, height: 44))
        self.viewBackBtn.setImage(UIImage.init(named: "back_gray"), for: .normal)
        self.viewBackBtn.tag = VIEW_BACK_BTN_TAG
        self.viewBackBtn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.view.addSubview(viewBackBtn)
        
        // MARK: - 自定义标题
        self.customTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        self.customTitleLabel.center = CGPoint(x: view.frame.width / 2, y: 20 + 22)
        self.customTitleLabel.text = username
        self.customTitleLabel.textAlignment = .center
        self.customTitleLabel.textColor = UIColor.colorFromRGB(0x1E90FF)
        self.customNavBar.addSubview(self.customTitleLabel)
        
        // MARK: - 当导航栏透明的时候的标题
        self.viewTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        self.viewTitleLabel.center = CGPoint(x: view.frame.width / 2, y: 20 + 22)
        self.viewTitleLabel.text = "个人资料"
        self.viewTitleLabel.textColor = UIColor.white
        self.view.addSubview(self.viewTitleLabel)
        
        // MARK: - 底部工具栏
        self.toolBar = UIToolbar(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 50, width: SCREEN_WIDTH, height: 50))
        self.view.addSubview(self.toolBar)
        
        self.toolBar.layoutIfNeeded()
        // MARK: - 联系她／他按钮
        self.contectButton = UIButton(frame: CGRect(x: 10, y: 10, width: (SCREEN_WIDTH - 40) / 2, height: 30))
        self.contectButton.tag = CONTECT_BUTTON_TAG
        self.contectButton.setTitle("联系他", for: .normal)
        self.contectButton.layer.cornerRadius = 5.0
        self.contectButton.backgroundColor = UIColor.colorFromRGB(0x1E90FF)
        self.contectButton.titleLabel?.textColor = UIColor.white
        self.contectButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.toolBar.addSubview(self.contectButton)
        
        // MARK: - 举报她／他按钮
        self.reportButton = UIButton(frame: CGRect(x: 10 + (SCREEN_WIDTH - 40) / 2 + 20, y: 10, width: (SCREEN_WIDTH - 40) / 2, height: 30))
        self.reportButton.tag = REPORT_BUTTON_TAG
        self.reportButton.setTitle("举报他", for: .normal)
        self.reportButton.layer.cornerRadius = 5.0
        self.reportButton.backgroundColor = UIColor.colorFromRGB(0x1E90FF)
        self.reportButton.titleLabel?.textColor = UIColor.white
        self.reportButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.toolBar.addSubview(self.reportButton)
        
        // MARK: - 用户头像
        self.userLogoView = UIImageView(frame: CGRect(x: SCREEN_WIDTH / 2 - 50, y: topImageHeight / 2 - 50, width: 100, height: 100))
        self.userLogoView.layer.cornerRadius = userLogoView.frame.size.width / 2
        self.userLogoView.layer.masksToBounds = true
        self.userLogoView.image = userLogo
        self.topImageView.addSubview(self.userLogoView)
        
        // MARK: - 用户名label
        self.nicknameLabel = UILabel(frame: CGRect(x: 0, y: topImageHeight / 2 + 65, width: SCREEN_WIDTH, height: 15))
        self.nicknameLabel.text = self.username
        self.nicknameLabel.textAlignment = .center
        self.nicknameLabel.textColor = UIColor.white
        self.topImageView.addSubview(self.nicknameLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 隐藏自带的导航栏
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 显示上一页面的导航栏
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
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
        default:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if customNavBar == nil || customBackBtn == nil || customTitleLabel == nil || viewBackBtn == nil || viewTitleLabel == nil {
            return
        }
        
        let offY = scrollView.contentOffset.y
        // 根据偏移量改变alpha的值
        customNavBar.alpha = (offY + 64) / (self.topImageHeight - 64) + 1
        // 设置图片的高度 和 Y 值
        if offY < -self.topImageHeight {
            self.topImageView.frame.origin.y = offY
            self.topImageView.frame.size.height = -offY
        }
        // 改变导航栏返回按钮的图片和标题颜色
        if offY >= -64 {
            self.customBackBtn.setImage(UIImage.init(named: "back_blue"), for: .normal)
            self.viewBackBtn.isHidden = true
            self.viewTitleLabel.isHidden = true
            self.customTitleLabel.textColor = UIColor.colorFromRGB(0x1E90FF)
        }else {
            self.customBackBtn.setImage(UIImage.init(named: "back_gray"), for: .normal)
            self.viewBackBtn.isHidden = false
            self.viewTitleLabel.isHidden = false
            self.customTitleLabel.textColor = UIColor.white
        }
    }
    
    // MARK: - 标题label初始化
    func initLabel(label: UILabel, text: String) {
        label.text = text
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
    }

    func buttonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.navigationController?.popViewController(animated: true)
        case CONTECT_BUTTON_TAG:
            let vc = BWConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: self.studentID!)
            vc?.title = self.username
            self.navigationController?.pushViewController(vc!, animated: true)
        case REPORT_BUTTON_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "reportTableViewController") as! BWReportTableViewController
            vc.reportedUserID = "hh"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}

