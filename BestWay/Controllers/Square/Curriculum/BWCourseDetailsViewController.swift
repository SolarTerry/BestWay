//
//  BWCourseDetailsViewController.swift
//  BestWay
//
//  Created by solar on 17/7/23.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 课程细节控制器
class BWCourseDetailsViewController: UIViewController {
    // MARK: - 课程
    var course: BWCourse!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化界面
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - 初始化界面
    func initView() {
        // label的size
        let labelHeight = 30
        let labelWidth = Int((SCREEN_WIDTH - 20) / 2)
        
        let courseTitleLabel = UILabel(frame: CGRect(x: 10, y: 60, width: labelWidth, height: labelHeight))
        initTitleLabel(title: "课程", label: courseTitleLabel)
        let courseLabel = UILabel(frame: CGRect(x: labelWidth + 10, y: 60, width: labelWidth, height: labelHeight))
        initLabel(title: course!.courseName!, label: courseLabel)
        
        let classroomTitleLabel = UILabel(frame: CGRect(x: 10, y: 60 + labelHeight, width: labelWidth, height: labelHeight))
        initTitleLabel(title: "教室", label: classroomTitleLabel)
        let classroomLabel = UILabel(frame: CGRect(x: labelWidth + 10, y: 60 + labelHeight, width: labelWidth, height: labelHeight))
        initLabel(title: course!.classroom!, label: classroomLabel)
        
        let teacherTitleLabel = UILabel(frame: CGRect(x: 10, y: 60 + 2 * labelHeight, width: labelWidth, height: labelHeight))
        initTitleLabel(title: "老师", label: teacherTitleLabel)
        let teacherLabel = UILabel(frame: CGRect(x: labelWidth + 10, y: 60 + 2 * labelHeight, width: labelWidth, height: labelHeight))
        initLabel(title: course!.teacher!, label: teacherLabel)
        
        let countTitleLabel = UILabel(frame: CGRect(x: 10, y: 60 + 3 * labelHeight, width: labelWidth, height: labelHeight))
        initTitleLabel(title: "节数", label: countTitleLabel)
        let countLabel = UILabel(frame: CGRect(x: labelWidth + 10, y: 60 + 3 * labelHeight, width: labelWidth, height: labelHeight))
        initLabel(title: "\(course!.start!)-\(course!.end!)", label: countLabel)
        
        let weekTitleLabel = UILabel(frame: CGRect(x: 10, y: 60 + 4 * labelHeight, width: labelWidth, height: labelHeight))
        initTitleLabel(title: "星期", label: weekTitleLabel)
        let weekLabel = UILabel(frame: CGRect(x: labelWidth + 10, y: 60 + 4 * labelHeight, width: labelWidth, height: labelHeight))
        initLabel(title: "\(course!.day!)", label: weekLabel)
        
        self.view.addSubview(courseTitleLabel)
        self.view.addSubview(courseLabel)
        self.view.addSubview(classroomTitleLabel)
        self.view.addSubview(classroomLabel)
        self.view.addSubview(teacherTitleLabel)
        self.view.addSubview(teacherLabel)
        self.view.addSubview(countTitleLabel)
        self.view.addSubview(countLabel)
        self.view.addSubview(weekTitleLabel)
        self.view.addSubview(weekLabel)
    }
    
    // MARK: - 初始化标题label
    func initTitleLabel(title: String, label: UILabel) {
        label.text = title
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkText
    }
    
    // MARK: - 初始化label
    func initLabel(title: String, label: UILabel) {
        label.text = title
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
    }

}
