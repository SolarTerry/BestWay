//
//  BWScoreSearchingViewController.swift
//  BestWay
//
//  Created by solar on 17/5/19.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 成绩查询页面控制器
class BWScoreSearchingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 统计按钮
    var statisticsButton: UIBarButtonItem!
    
    // MARK: - 学期选择下拉框
    var semesterDropBoxView: BWDropBoxView!
    
    // MARK: - 可选择的学期
    var choices: [String] = []
    
    // MARK: - 学期id数组
    var semesterId: [Int] = []
    
    // MARK: - 默认学期为全部
    let defaultTitle = "全部学年"
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 成绩结构体
    struct score {
        // 课程学期
        var semester: String!
        // 课程名
        var className: String!
        // 成绩
        var score: String!
        // 课程时间
        var classTime: String!
        // 学分
        var credit: String!
        // 绩点
        var GPA: String!
    }
    
    // MARK: -  成绩数组
    var scoreArray: [score] = []
    
    override func viewWillAppear(_ animated: Bool) {
        // 显示导航栏
        self.navigationController?.isNavigationBarHidden = false
        // 标题
        self.navigationItem.title = "成绩查询"
        // 隐藏底部导航栏
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 统计按钮
        self.statisticsButton = UIBarButtonItem(title: "统计", style: UIBarButtonItemStyle.plain, target: self, action: #selector(statisticsButtonClicked(_:)))
        self.navigationItem.rightBarButtonItem = self.statisticsButton
        
        // 模拟用户数据
        choices = ["大一第一学期", "大一第二学期", "全部学年"]
        scoreArray = [
            score(semester: "大一第一学期", className: "c程序设计", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第一学期", className: "高等数学上", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第一学期", className: "大学英语", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第一学期", className: "思修", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第一学期", className: "体育1", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第一学期", className: "选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第一学期", className: "选修选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "Java程序设计", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "线性代数", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "概率论与数理统计", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "数据结构", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "选修选修选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "选修选修选修选修课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "高等数学下", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "中国近代史", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "替换课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
            score(semester: "大一第二学期", className: "替换替换课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1")
        ]
        
        // 学期选择下拉框
        semesterDropBoxView = BWDropBoxView(parentVC: self.view, title: defaultTitle, items: choices, frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + 20, width: SCREEN_WIDTH, height: 30))
        semesterDropBoxView.isHightWhenShowList = true
        semesterDropBoxView.willShowOrHideBoxListHandler = { (isShow) in
            if isShow {
                print("show")
            }else {
                print("notshow")
            }
        }
        semesterDropBoxView.didSelectBoxItemHandler = {(row) in
            // 模拟网络获取数据
            switch self.semesterDropBoxView.currentTitle() {
            case self.choices[0]:
                self.scoreArray = [
                    score(semester: "大一第一学期", className: "c程序设计", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "高等数学上", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "大学英语", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "思修", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "体育1", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "选修选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1")
                ]
                self.tableView.reloadData()
            case self.choices[1]:
                self.scoreArray = [
                    score(semester: "大一第二学期", className: "Java程序设计", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "线性代数", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "概率论与数理统计", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "数据结构", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "选修选修选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "选修选修选修选修课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "高等数学下", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "中国近代史", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "替换课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "替换替换课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1")
                ]
                self.tableView.reloadData()
            default:
                self.scoreArray = [
                    score(semester: "大一第一学期", className: "c程序设计", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "高等数学上", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "大学英语", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "思修", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "体育1", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第一学期", className: "选修选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "Java程序设计", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "线性代数", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "概率论与数理统计", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "数据结构", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "选修选修选修课", score: "91", classTime: "2014-2015第一学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "选修选修选修选修课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "高等数学下", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "中国近代史", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "替换课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1"),
                    score(semester: "大一第二学期", className: "替换替换课", score: "91", classTime: "2014-2015第二学年", credit: "5.0", GPA: "4.1")
                ]
                self.tableView.reloadData()
            }
        }
        
        // 主tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: self.semesterDropBoxView.frame.origin.y + 30, width: SCREEN_WIDTH, height: (SCREEN_HEIGHT - self.semesterDropBoxView.frame.origin.y - 30)))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 设置cell的默认高度
        self.tableView.estimatedRowHeight = 44.0
        // 设置cell根据BWScoreTableViewCell高度而改变高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        
        self.view.addSubview(self.semesterDropBoxView)
        self.view.addSubview(self.tableView)
        self.view.bringSubview(toFront: self.semesterDropBoxView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 统计按钮点击监听方法
    func statisticsButtonClicked(_ sender: UIBarButtonItem) {
        BWScoreStatisticsAlertView().showAlert("124", score: "91", GPA: "4.1"){(OtherButton) -> Void in
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 判断成绩数组是否为空
        if self.scoreArray.isEmpty {
            return 1
        }else {
            return self.scoreArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 判断成绩数组是否为空
        if scoreArray.isEmpty {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let reuseIdentifier = "cell"
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
            cell?.selectionStyle = .none
            // 如果成绩数组为空则显示暂无信息
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (cell?.frame.size.height)!))
            label.text = "暂无信息"
            label.textAlignment = .center
            cell?.addSubview(label)
            return cell!
        } else {
            // 注册BWScoreTableViewCell
            tableView.register(UINib(nibName: "BWScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "scoreTableViewCell")
            // 给BWScoreTableViewCell里的所有label赋值
            let cell = tableView.dequeueReusableCell(withIdentifier: "scoreTableViewCell") as! BWScoreTableViewCell
            cell.courseAndCreditLabel.text = "\(self.scoreArray[indexPath.section].className!)/\(self.scoreArray[indexPath.section].credit!)"
            cell.courseTimeLabel.text = self.scoreArray[indexPath.section].classTime!
            cell.scoreAndGPALabel.text = "\(self.scoreArray[indexPath.section].score!)/\(self.scoreArray[indexPath.row].GPA!)"
            // 将BWScoreTableViewCell设为不可选
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
