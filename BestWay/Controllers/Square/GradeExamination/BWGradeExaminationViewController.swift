//
//  BWGradeExaminationViewController.swift
//  BestWay
//
//  Created by solar on 17/5/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 等级考试查询页面控制器
class BWGradeExaminationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 考试信息结构体
    struct gradeExamination {
        // MARK: - 考试名称
        var examination: String!
        // MARK: - 准考证号
        var admissionTicketNumber: String!
        // MARK: - 考试时间
        var examinationTime: String!
        // MARK: - 考试地点
        var examinationRoom: String!
        // MARK: - 座位号
        var seatNumber: String!
        // MARK: - 考试成绩
        var grade: String!
    }
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 考试信息数组
    var examinationArray: [gradeExamination] = []
    
    override func viewWillAppear(_ animated: Bool) {
        // 隐藏tabbar
        self.tabBarController?.tabBar.isHidden = true
        // 显示导航栏
        self.navigationController?.isNavigationBarHidden = false
        // 导航栏标题
        self.navigationItem.title = "等级考试"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 模拟数据
        self.examinationArray = [
            gradeExamination(examination: "CET-4(英语四级)", admissionTicketNumber: "440860151113020", examinationTime: "2015-6-13", examinationRoom: "丽泽楼D106", seatNumber: "56", grade: "487"),
            gradeExamination(examination: "CET-6(英语六级)", admissionTicketNumber: "440860152207204", examinationTime: "2015-12-19", examinationRoom: "丽泽楼D206", seatNumber: "6", grade: "424"),
            gradeExamination(examination: "CET-6(英语六级)", admissionTicketNumber: "440860161200509", examinationTime: "2016-6-18", examinationRoom: "", seatNumber: "", grade: "")
        ]
        //self.examinationArray = []
        
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
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 判断考试信息是否为空
        if self.examinationArray.isEmpty {
            return 1
        }else {
            return self.examinationArray.count
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
        if self.examinationArray.isEmpty {
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
            // 注册BWGradeExaminationTableViewCell
            tableView.register(UINib(nibName: "BWGradeExaminationTableViewCell", bundle: nil), forCellReuseIdentifier: "gradeExaminationTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "gradeExaminationTableViewCell") as! BWGradeExaminationTableViewCell
            // 禁止点击
            cell.selectionStyle = .none
            // 给所有label的text赋值
            cell.examinationLabel.text = self.examinationArray[indexPath.section].examination
            cell.admissionTicketNumberLabel.text = self.examinationArray[indexPath.section].admissionTicketNumber
            cell.examinationTimeLabel.text = self.examinationArray[indexPath.section].examinationTime
            if self.examinationArray[indexPath.section].examinationRoom == "" || self.examinationArray[indexPath.section].seatNumber == "" {
                cell.examinationRoomLabel.text = "暂无考试地点"
                cell.seatNumberLabel.text = "暂无座位号"
            }else {
                cell.examinationRoomLabel.text = self.examinationArray[indexPath.section].examinationRoom
                cell.seatNumberLabel.text = self.examinationArray[indexPath.section].seatNumber
            }
            if self.examinationArray[indexPath.section].grade == "" {
                cell.gradeLabel.text = "暂无成绩"
            }else {
                cell.gradeLabel.text = self.examinationArray[indexPath.section].grade
            }

            return cell
        }
    }
}
