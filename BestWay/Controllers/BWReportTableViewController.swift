//
//  BWReportTableViewController.swift
//  BestWay
//
//  Created by solar on 17/5/7.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit

// 举报页面控制器
class BWReportTableViewController: UITableViewController {
    // MARK: - 被举报用户ID
    var reportedUserID: String!
    
    // MARK: - 举报信息编号
    var reportedInfoId: String!
    
    // MARK: - 举报条目
    let reportItem = [["0", "泄漏隐私"],
                      ["1", "人身攻击"],
                      ["2", "淫秽色情"],
                      ["3", "垃圾广告"],
                      ["4", "敏感信息"],
                      ["5", "不实信息"],
                      ["6", "恶意刷屏"],
                      ["7", "其他"]]
    
    // MARK: - 主storyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reportedInfoId = "aa"
        // 导航栏标题
        self.navigationItem.title = "举报"
        // 改变背景色
        self.tableView.backgroundColor = UIColor(red: 0.96247226, green: 0.9624947906, blue: 0.9624827504, alpha: 1)
        self.tableView.isScrollEnabled = false
        // 去掉多余的tableViewCell
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        // 如果为第一个cell，则在顶部添加一条直线作为边框
        if indexPath.row == 0 {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5))
            line.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            cell.addSubview(line)
            print(tableView.numberOfRows(inSection: indexPath.section))
        }
        // 如果为最后一个cell，则在底部添加一条直线作为边框
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1{
            let underline = UIView(frame: CGRect(x: 0, y: 43.5, width: self.view.frame.size.width, height: 0.5))
            underline.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            cell.addSubview(underline)
        }
        cell.textLabel?.text = reportItem[indexPath.row][1]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - 选择选项回调方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "addReportEvidenceViewController") as! BWAddReportEvidenceViewController
        // 页面穿參
        vc.reportedUserID = reportedUserID
        vc.reportedInfoID = reportedInfoId
        vc.reportTitle = reportItem[indexPath.row][1]
        vc.reportTag = reportItem[indexPath.row][0]
        // 页面跳转
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
