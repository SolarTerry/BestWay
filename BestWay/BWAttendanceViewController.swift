//
//  BWAttendanceViewController.swift
//  BestWay
//
//  Created by solar on 17/5/24.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 考勤查询页面控制器
class BWAttendanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 考勤信息结构体
    struct attendance {
        // MARK: - 课程名称
        var course: String!
        // MARK: - 课程时间
        var time: String!
        // MARK: - 课程状态，0:旷课，1:迟到，2:早退
        var status: Int!
    }
    
    // MARK: - 考勤信息数组
    var attendanceArray: [attendance] = []
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 考勤状态
    var status: Dictionary<Int, String> = [0: "旷课", 1: "迟到", 2: "早退"]
    
    override func viewWillAppear(_ animated: Bool) {
        // 显示导航栏
        self.navigationController?.isNavigationBarHidden = false
        // 设置导航栏标题
        self.navigationItem.title = "我的考勤"
        // 隐藏底部导航栏
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 模拟数据
        attendanceArray = [
            attendance(course: "Java程序设计", time: "2017-1-1 第六周", status: 1),
            attendance(course: "C程序设计", time: "2017-1-4 第六周", status: 0),
            attendance(course: "高等数学", time: "2017-1-7 第七周", status: 1),
            attendance(course: "概率论与数理统计概率论与数理统计概率论与数理统计", time: "2017-1-1 第六周", status: 1),
            attendance(course: "Java程序设计", time: "2017-1-1 第六周", status: 2),
            attendance(course: "Java程序设计", time: "2017-1-1 第六周", status: 1)
        ]
        //attendanceArray = []
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 设置cell的默认高度
        self.tableView.estimatedRowHeight = 44
        // 设置cell根据BWScoreTableViewCell高度而改变高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 判断考勤信息是否为空
        if self.attendanceArray.isEmpty {
            return 1
        }else {
            return self.attendanceArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 判断考勤信息是否为空
        if self.attendanceArray.isEmpty {
            // 禁止滚动
            tableView.isScrollEnabled = false
            // 注册cell
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let reuseIdentifier = "cell"
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
            cell?.selectionStyle = .none
            // 如果考勤信息为空则显示暂无不良考勤信息label
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (cell?.frame.height)!))
            label.text = "暂无不良考勤信息"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.darkGray
            
            cell?.addSubview(label)
            
            return cell!
        }else {
            // 注册cell
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let reuseIdentifier = "cell"
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
            cell?.selectionStyle = .none
            // 如果考勤信息不为空，则显示考勤信息
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: SCREEN_WIDTH / 8, height: (cell?.frame.height)! - 20))
            titleLabel.text = self.status[self.attendanceArray[indexPath.section].status]
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.layer.cornerRadius = 9.0
            titleLabel.layer.masksToBounds = true
            // 根据考勤状态设置titlelabel的背景色
            switch self.attendanceArray[indexPath.section].status! {
            // 旷课
            case 0:
                titleLabel.backgroundColor = UIColor.red
            // 迟到
            case 1:
                titleLabel.backgroundColor = UIColor.blue
            // 早退
            case 2:
                titleLabel.backgroundColor = UIColor.orange
            default:
                titleLabel.backgroundColor = UIColor.orange
            }
            // 详细信息
            let infoLabel = UILabel(frame: CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.size.width + 5, y: 10, width: SCREEN_WIDTH - titleLabel.frame.origin.x - titleLabel.frame.size.width - 5, height: (cell?.frame.height)! - 20))
            infoLabel.text = "\(self.attendanceArray[indexPath.section].course!)/\(self.attendanceArray[indexPath.section].time!)"
            infoLabel.font = UIFont.systemFont(ofSize: 14)
            infoLabel.textColor = UIColor.darkGray
            infoLabel.lineBreakMode = .byCharWrapping
            infoLabel.numberOfLines = 0
            infoLabel.sizeToFit()
            
            cell?.addSubview(infoLabel)
            cell?.addSubview(titleLabel)
            
            return cell!
        }
    }
}
