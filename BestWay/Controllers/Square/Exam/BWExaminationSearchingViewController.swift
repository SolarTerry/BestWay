//
//  BWExaminationSearchingViewController.swift
//  BestWay
//
//  Created by solar on 17/5/20.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 考试查询页面控制器
class BWExaminationSearchingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 考试信息结构体
    struct exam {
        // 考试名称
        var exam: String!
        // 考试时间
        var examTime: String!
        // 考试地点
        var examPlace: String!
        // 考试座位号
        var seatNumber: String!
        // 考试倒计时
        var examCountDown: String!
    }
    
    // MARK: - 考试信息数组
    var examArray: [exam] = []
    
    override func viewWillAppear(_ animated: Bool) {
        // 显示导航栏
        self.navigationController?.isNavigationBarHidden = false
        // 导航栏标题
        self.navigationItem.title = "我的考试"
        // 隐藏tabbar
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 模拟数据
        self.examArray = [
            exam(exam: "c程序设计", examTime: "2017-1-1(10:00-11:30)", examPlace: "丽泽楼A206", seatNumber: "57", examCountDown: "5天"),
            exam(exam: "软件工程", examTime: "2017-1-3(10:00-11:30)", examPlace: "丽泽楼D206", seatNumber: "57", examCountDown: "7天"),
            exam(exam: "Java程序设计", examTime: "2017-1-7(10:00-11:30)", examPlace: "丽泽楼A106", seatNumber: "57", examCountDown: "9天"),
            exam(exam: "高等数学上", examTime: "2017-1-11(10:00-11:30)", examPlace: "丽泽楼A206", seatNumber: "57", examCountDown: "13天"),
            exam(exam: "概率论与数理统计", examTime: "2017-1-1(13:40-15:10)", examPlace: "丽泽楼A206", seatNumber: "57", examCountDown: "5天")
        ]
        
        //self.examArray = []
        
        // 主tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + (self.navigationController?.navigationBar.frame.height)!))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 设置cell的默认高度
        self.tableView.estimatedRowHeight = 44.0
        // 设置cell根据BWScoreTableViewCell高度而改变高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(self.tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 判断考试信息是否为空
        if self.examArray.isEmpty {
            return 1
        }else {
            return examArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        // 判断考试信息是否为空
        if self.examArray.isEmpty {
            // 注册cell
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let reuseIdentifier = "cell"
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
            // 显示暂无信息的label
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (cell?.frame.size.height)!))
            label.text = "暂无考试信息"
            label.textAlignment = .center
            cell?.addSubview(label)
            
            return cell!
        }else {
            // 注册BWExamTableViewCell
            tableView.register(UINib(nibName: "BWExamTableViewCell", bundle: nil), forCellReuseIdentifier: "examTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "examTableViewCell") as! BWExamTableViewCell
            // 禁止点击
            cell.selectionStyle = .none
            // 给所有label的text赋值
            cell.examLabel.text = examArray[indexPath.section].exam
            cell.timeLabel.text = examArray[indexPath.section].examTime
            cell.placeLabel.text = examArray[indexPath.section].examPlace
            cell.seatNumberLabel.text = examArray[indexPath.section].seatNumber
            cell.countDownLabel.text = examArray[indexPath.section].examCountDown
            
            return cell
        }
    }
}
