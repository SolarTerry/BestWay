//
//  BWAddFleaMarketViewController.swift
//  BestWay
//
//  Created by solar on 17/5/18.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD
// 添加二手商品信息页面控制器
class BWAddFleaMarketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    // MARK: - 取消按钮
    var cancelButton: UIButton!
    
    // MARK: - 取消按钮tag
    let CANCEL_BUTTON_TAG = 0
    
    // MARK: - 发送按钮
    var sendButton: UIButton!
    
    // MARK: - 发送按钮tag
    let SEND_BUTTON_TAG = 1
    
    // MARK: - 主storyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 导航栏标题
    var navBarLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化界面
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 标题label初始化
    func initLabel(label: UILabel, text: String) {
        label.text = text
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 3:
            return 100
        case 4:
            return 300
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 导航栏view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        // 信息输入框标题label
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: SCREEN_WIDTH, height: 20))
        // 输入框标题
        switch section {
        case 0:
            initLabel(label: label, text: "商品名称")
            view.addSubview(label)
            return view
        case 1:
            initLabel(label: label, text: "商品价格")
            view.addSubview(label)
            return view
        case 2:
            initLabel(label: label, text: "联系电话")
            view.addSubview(label)
            return view
        case 3:
            initLabel(label: label, text: "备注(非必填)")
            view.addSubview(label)
            return view
        case 4:
            initLabel(label: label, text: "上传图片(最多可上传9张)")
            view.addSubview(label)
            return view
        default:
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            self.tableView.register(BWTextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! BWTextFieldTableViewCell
            textCell.textFieldLabel.placeholder = "请填写商品关键字，例：热水卡、雨伞"
            textCell.backgroundColor = UIColor.init(red: 84 / 255, green: 166 / 255, blue: 242 / 255, alpha: 0.1)
            return textCell
        case 1:
            self.tableView.register(BWTextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! BWTextFieldTableViewCell
            textCell.textFieldLabel.placeholder = "请填写商品价格，单位：人民币"
            textCell.textFieldLabel.keyboardType = .numberPad
            textCell.backgroundColor = UIColor.init(red: 84 / 255, green: 166 / 255, blue: 242 / 255, alpha: 0.1)
            return textCell
        case 2:
            self.tableView.register(BWTextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! BWTextFieldTableViewCell
            textCell.textFieldLabel.placeholder = "请填写联系电话"
            textCell.textFieldLabel.keyboardType = .numberPad
            textCell.backgroundColor = UIColor.init(red: 84 / 255, green: 166 / 255, blue: 242 / 255, alpha: 0.1)
            return textCell
        case 3:
            self.tableView.register(BWTextViewTableViewCell.self, forCellReuseIdentifier: "textViewCell")
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textViewCell", for: indexPath) as! BWTextViewTableViewCell
            textCell.textView.backgroundColor = UIColor.clear
            textCell.textView.placeholderText = "请填写备注"
            textCell.backgroundColor = UIColor.init(red: 84 / 255, green: 166 / 255, blue: 242 / 255, alpha: 0.1)
            return textCell
        case 4:
            self.tableView.register(BWAddPhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
            let photoCell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! BWAddPhotoTableViewCell
            return photoCell
        default:
            self.tableView.register(BWTextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! BWTextFieldTableViewCell
            return textCell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - 初始化界面
    func initView() {
        // 取消按钮相关属性
        self.cancelButton = UIButton(frame: CGRect(x: 10, y: 30, width: 40, height: 40))
        self.cancelButton.tag = CANCEL_BUTTON_TAG
        self.cancelButton.setBackgroundImage(UIImage.init(named: "cancel"), for: UIControlState.normal)
        self.cancelButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        // 发送按钮相关属性
        self.sendButton = UIButton(frame: CGRect(x: SCREEN_WIDTH - 50.0, y: 30, width: 40, height: 40))
        self.sendButton.tag = SEND_BUTTON_TAG
        self.sendButton.setBackgroundImage(UIImage.init(named: "send"), for: UIControlState.normal)
        self.sendButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        // 导航栏标题
        self.navBarLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH / 2 - 100.0, y: 30, width: 200, height: 40))
        navBarLabel.text = "我的跳蚤市场"
        navBarLabel.font = UIFont.systemFont(ofSize: 18)
        navBarLabel.textColor = UIColor.colorFromRGB(0x1E90FF)
        navBarLabel.textAlignment = .center
        
        // 初始化主tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: 70, width: self.view.frame.size.width, height: self.view.frame.size.height - 80), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.sendButton)
        self.view.addSubview(self.navBarLabel)
        self.view.addSubview(self.tableView)
        
        // 添加一个tableViewController来防止软键盘被挡住
        let tableVC = UITableViewController.init(style: .plain)
        tableVC.tableView = self.tableView
        self.addChildViewController(tableVC)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - 按钮处理方法
    func buttonClicked(sender: UIButton) {
        switch sender.tag {
        // 取消按钮处理方法
        case CANCEL_BUTTON_TAG:
            let alertViewController = UIAlertController.alertControllerWithAction("提示", msg: "确定要放弃编辑吗？", actionTitle: "确认", action: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alertViewController, animated: true, completion: nil)
            
        // 发送按钮处理方法
        case SEND_BUTTON_TAG:
            SVProgressHUD.showSuccess(withStatus: "发布成功！请刷新查看")
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}
