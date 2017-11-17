//
//  BWAddReportEvidenceViewController.swift
//  BestWay
//
//  Created by solar on 17/5/7.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD

// 填写举报信息页面控制器
class BWAddReportEvidenceViewController: UIViewController {
    // MARK: - 被举报用户ID
    var reportedUserID: String!
    
    // MARK: - 举报信息编号
    var reportedInfoID: String!
    
    // MARK: - 举报标题
    var reportTitle: String!
    
    // MARK: - 举报状态码
    var reportTag: String!
    
    // MARK: - 发送按钮
    var rightBarButton: UIBarButtonItem!
    
    // MARK: - 发送按钮tag
    let RIGHT_BAR_BUTTON_TAG = 0
    
    // MARK: - 主tableview
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化界面
        initView()
        
    }
    
    func buttonClicked(_ sender: UIButton) {
        switch sender.tag {
        // 发送按钮
        case RIGHT_BAR_BUTTON_TAG:
            SVProgressHUD.showSuccess(withStatus: "举报成功!")
            // 返回失物招领列表页面
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
        default:
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 初始化界面
    func initView() {
        // 页面标题为举报原因
        self.navigationItem.title = reportTitle
        
        // MARK: - 发送按钮初始化
        rightBarButton = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.buttonClicked(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        print("被举报用户:\(reportedUserID!), 举报条目:\(reportTitle!)")
        
        // MARK: - 初始化主tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 5, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (self.navigationController?.navigationBar.frame.height)! - 5))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        
        self.view.addSubview(self.tableView)
        
        // 添加一个tableViewController来防止软键盘被挡住
        let tableVC = UITableViewController.init(style: .plain)
        tableVC.tableView = self.tableView
        self.addChildViewController(tableVC)
        
        self.automaticallyAdjustsScrollViewInsets = false
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
// BWAddReportEvidenceViewController的UITableViewDelegate、UITableViewDataSource代理方法实现
extension BWAddReportEvidenceViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        // 举报原因简述cell高度
        case 0:
            return 100
        // 举报证据cell高度
        case 1:
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
            initLabel(label: label, text: "举报原因简述")
            view.addSubview(label)
            return view
        case 1:
            initLabel(label: label, text: "举报证据(非必填)")
            view.addSubview(label)
            return view
        default:
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建单元格重用
        switch indexPath.section {
        // 简述举报原因输入框
        case 0:
            self.tableView.register(BWTextViewTableViewCell.self, forCellReuseIdentifier: "textViewCell")
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textViewCell", for: indexPath) as! BWTextViewTableViewCell
            textCell.textView.backgroundColor = UIColor.clear
            textCell.textView.placeholderText = "请输入举报原因"
            textCell.backgroundColor = UIColor.init(red: 84 / 255, green: 166 / 255, blue: 242 / 255, alpha: 0.1)
            return textCell
        // 举报证据上传图片
        case 1:
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
    
    // MARK: - 标题label初始化
    func initLabel(label: UILabel, text: String) {
        label.text = text
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
    }
}
