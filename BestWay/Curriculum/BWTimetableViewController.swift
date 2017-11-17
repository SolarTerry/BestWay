//
//  BWTimetableViewController.swift
//  BestWay
//
//  Created by solar on 17/7/23.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

// 课程安排控制器
class BWTimetableViewController: UIViewController {
    // MARK: - 时间collectionview（表头）
    @IBOutlet weak var dateCollectionView: UICollectionView!
    // MARK: - 课程collectionview（课程内容）
    @IBOutlet weak var courseCollectionView: UICollectionView!
    // MARK: - 表头tag
    let DATE_COLLECTION_VIEW_TAG = 0
    // MARK: - 课程内容
    let COURSE_COLLECTION_VIEW_TAG = 1
    // MARK: - 表头
    var weekItems = ["周一", "周二", "周三", "周四", "周五","周六","周日"]
    // MARK: - 图片view
    var imageView: UIImageView!
    // MARK: - 课程单元格大小
    var courseCellSize: CGSize!
    // MARK: - 课程单元格背景色
    var courseColor: UIColor!
    // MARK: - 课程数组
    var courseArray = [BWCourse]()
    // MARK: - 课程label数组
    var courseLabelArray = [UILabel]()
    // MARK: - 背景图
    var bgImageView: UIImageView!
    // MARK: -  刷新课表按钮
    var updateTableButtonItem: UIBarButtonItem!
    // MARK: - 主storyboard
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化界面
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 初始化界面
    func initView() {
        self.navigationItem.title = "课程表"
        // 背景图设置
        bgImageView = UIImageView(frame: self.view.frame)
        bgImageView.image = UIImage.init(named: "bg")
        self.view.insertSubview(bgImageView, belowSubview: dateCollectionView)
        // 设置课程单元格背景色
        courseColor = UIColor(red: 74/255, green: 187/255, blue: 230/255, alpha: 1)
        // 注册cell
        dateCollectionView.register(UINib(nibName: "BWCurriculumDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dateCell")
        courseCollectionView.register(UINib(nibName: "BWCurriculumDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dateCell")
        courseCollectionView.register(UINib(nibName: "BWCurriculumCourseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "courseCell")
        // 设置tag
        dateCollectionView.tag = DATE_COLLECTION_VIEW_TAG
        courseCollectionView.tag = COURSE_COLLECTION_VIEW_TAG
        // 设置代理
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
        // 设置课程表透明度
        dateCollectionView.alpha = 0.5
        courseCollectionView.alpha = 0.5
        // 禁止滚动
        self.automaticallyAdjustsScrollViewInsets = false
        // 清空按钮
        updateTableButtonItem = UIBarButtonItem(title: "点击刷新", style: UIBarButtonItemStyle.plain, target: self, action: #selector(updataCourseTable))
        // 将按钮添加到导航栏
        self.navigationItem.rightBarButtonItem = updateTableButtonItem
        // 计算每个课程格子的size
        let rowHeight = CGFloat((SCREEN_HEIGHT - 64 - 30) / 12)
        courseCellSize = CGSize(width: (SCREEN_WIDTH - 30) / 7, height: rowHeight)
        // 刷新数据
        courseCollectionView.reloadData()
        // 加载课程
        loadCourse()
        // 将课程label添加进view
        for courseItem in self.courseArray {
            drawCourse(courseItem)
        }
    }
    
    // MARK: - 绘画课程单元格
    func drawCourse(_ course: BWCourse) {
        // 计算要画的地方
        let rowNum = course.end - course.start + 1
        let width = courseCellSize.width
        let height = courseCellSize.height * CGFloat(rowNum)
        let x = CGFloat(30) + CGFloat(course.day - 1) * courseCellSize.width
        let y = CGFloat(30 + 64) + CGFloat(course.start - 1) * courseCellSize.height
        let courseView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        courseView.alpha = 0.8
        
        // 显示课程信息的label
        let courseInfoLabel = UILabel(frame: CGRect(x: 0, y: 2, width: courseView.frame.size.width - 2, height: courseView.frame.size.height))
        courseInfoLabel.numberOfLines = 5
        courseInfoLabel.font = UIFont.systemFont(ofSize: 12)
        courseInfoLabel.textAlignment = .left
        courseInfoLabel.textColor = UIColor.white
        courseInfoLabel.text = "\(course.courseName!)@\(course.classroom!)"
        courseInfoLabel.tag = self.courseArray.index(of: course)!
        courseInfoLabel.layer.cornerRadius = 5
        courseInfoLabel.layer.masksToBounds = true
        courseInfoLabel.backgroundColor = courseColor
        courseView.addSubview(courseInfoLabel)
        self.courseLabelArray.append(courseInfoLabel)
        
        // 点击显示课程详细信息手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(showCourseDetail(_:)))
        courseInfoLabel.addGestureRecognizer(tap)
        courseInfoLabel.isUserInteractionEnabled = true
        
        // 将要画的地方画上去
        self.view.insertSubview(courseView, aboveSubview: courseCollectionView)
    }
    
    // MARK: - 显示课程详细信息
    func showCourseDetail(_ recognizer: UIGestureRecognizer) {
        // 获取手势所在的label
        let label = recognizer.view as! UILabel
        let vc = storyBoard.instantiateViewController(withIdentifier: "courseDetailsViewController") as! BWCourseDetailsViewController
        // 根据label的tag获取label上的Course对象
        vc.course = courseArray[label.tag]
        // 页面跳转
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 删除课程信息
    func deleteCourse(_ course: BWCourse, tag: Int) {
        // 获取课程所在view
        let courseView = self.courseLabelArray[tag].superview
        // 去除这个view
        courseView?.removeFromSuperview()
        self.courseArray.remove(at: tag)
        self.courseLabelArray.remove(at: tag)
    }
    
    // MARK: - 清空课表
    func clearTable() {
        // 打开数据库
        let dbOperations = BWDatabaseOperations.shared
        // 清空表
        _ = dbOperations.cleanTable()
        // 清除label
        for courseLabel in courseLabelArray {
            let courseView = courseLabel.superview
            courseView?.removeFromSuperview()
        }
        // 清空课程数组
        courseArray = []
        courseLabelArray = []
        // 刷新表格
        view.reloadInputViews()
    }
    
    // MARK: - 加载课表
    /*
     返回结果为Int：
     1:获取课表成功
     2:网络问题获取失败
     3:教务账号密码失效，重新登录
     */
    func load() -> Int {
        
        // 模拟一节课
        let course = BWCourse()
        course.courseName = "高等数学"
        course.teacher = "高数学"
        course.classroom = "数学楼A206"
        course.day = 1
        course.start = 7
        course.end = 8
        course.weeks = 17
        self.addCourse(course)
        
        // 这里开始网络获取数据，但是没有接口
        
        // 重新加载课程
        loadCourse()
        for courseItem in self.courseArray {
            drawCourse(courseItem)
        }
        // 刷新表格
        view.reloadInputViews()
        
        return 1
    }
    
    // MARK: - 添加课程信息
    func addCourse(_ course: BWCourse) {
        
        // 将课程追加到数组
        courseArray.append(course)
        
        // 打开数据库
        let dbOperations = BWDatabaseOperations.shared

        // 插入课程
        _ = dbOperations.addCourse(course: course)
        
    }
    
    // MARK: - 加载课程信息
    func loadCourse() {
        
        // 打开数据库
        let dbOperations = BWDatabaseOperations.shared
        
        courseArray = dbOperations.getAllCourse()
        
        print(courseArray)
    }
    
    // MARK: - 更新课表
    func updataCourseTable() {
        SVProgressHUD.show(withStatus: "刷新中")
        
        // 清除课表
        clearTable()
        
        // 重新加载新课表
        let loadResult = load()
        
        if loadResult == 1 {
            SVProgressHUD.showSuccess(withStatus: "刷新成功！")
        }else if loadResult == 2{
            SVProgressHUD.showError(withStatus: "刷新失败😔")
        }else if loadResult == 3{
            SVProgressHUD.showError(withStatus: "教务密码已失效，请重新登录")
            UserDefaults.standard.removeObject(forKey: "rcToken")
            UserDefaults.standard.removeObject(forKey: "BWUser")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "userLogo")
            RCIM.shared().logout()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
            self.present(vc!, animated: true, completion: nil)
        }
    }
}

extension BWTimetableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView.tag {
        case DATE_COLLECTION_VIEW_TAG:
            return 1
        case COURSE_COLLECTION_VIEW_TAG:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case DATE_COLLECTION_VIEW_TAG:
            return weekItems.count + 1
        case COURSE_COLLECTION_VIEW_TAG:
            return (weekItems.count + 1) * 12
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case DATE_COLLECTION_VIEW_TAG:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! BWCurriculumDateCollectionViewCell
            if indexPath.row == 0 {
                cell.dateLabel.text = ""
            }else {
                cell.dateLabel.text = weekItems[indexPath.row - 1]
            }
            return cell
        case COURSE_COLLECTION_VIEW_TAG:
            if indexPath.row % 8 == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! BWCurriculumDateCollectionViewCell
                cell.dateLabel.text = "\(indexPath.row / (weekItems.count + 1) + 1)"
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath) as! BWCurriculumCourseCollectionViewCell
                cell.courseLabel.text = ""
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
}

extension BWTimetableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case DATE_COLLECTION_VIEW_TAG:
            if indexPath.row == 0 {
                return CGSize(width: 30, height: 30)
            }else {
                return CGSize(width: (SCREEN_WIDTH - 30) / 7, height: 30)
            }
        case COURSE_COLLECTION_VIEW_TAG:
            let rowHeight = CGFloat((SCREEN_HEIGHT - 64 - 30) / 12)
            if indexPath.row % 8 == 0 {
                return CGSize(width: 30, height: rowHeight)
            }else {
                courseCellSize = CGSize(width: (SCREEN_WIDTH - 30) / 7, height: rowHeight)
                return courseCellSize
            }
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
