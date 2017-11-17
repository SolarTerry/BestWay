//
//  BWSquareTableViewController.swift
//  BestWay
//
//  Created by solar on 16/12/9.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
import SDCycleScrollView
import Alamofire
import SwiftyJSON
import SVProgressHUD
// 广场页面控制器
class BWSquareTableViewController: UITableViewController,UINavigationControllerDelegate {
    
    // MARK: - 主storyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - 图片轮播tag
    let SCROLL_VIEW_TAG = 0
    
    // MARK: - 快递中心按钮
    var expressBtn = UIButton()
    
    // MARK: - 快递中心按钮tag
    let EXPRESS_BTN_TAG = 1
    
    // MARK: - 失物招领按钮
    var lostAndFoundBtn = UIButton()
    
    // MARK: - 失物招领按钮tag
    let LOST_AND_FOUND_BTN_TAG = 2
    
    // MARK: - 跳蚤市场按钮
    var fleaMarketBtn = UIButton()
    
    // MARK: - 跳蚤市场按钮tag
    let FLEA_MARKET_BTN_TAG = 3
    
    // MARK: - 图书馆按钮
    var libraryBtn = UIButton()
    
    // MARK: - 网费查询按钮tag
    let LIBRARY_BTN_TAG = 4
    
    // MARK: - 成绩查询按钮
    var scoreSearchingBtn = UIButton()
    
    // MARK: - 成绩查询按钮tag
    let SCORE_SEARCHING_BTN_TAG = 5
    
    // MARK: - 考试查询按钮
    var examinationSearchingBtn = UIButton()
    
    // MARK: - 考试查询按钮tag
    let EXAMINATION_SEARCHING_BTN_TAG = 6
    
    // MARK: - 课程安排按钮
    var curriculumScheduleBtn = UIButton()
    
    // MARK: - 课程安排按钮tag
    let CURRICULUM_SCHEDULE_BTN_TAG = 7
    
    // MARK: - 等级考试查询按钮
    var gradeExaminationBtn = UIButton()
    
    // MARK: - 等级考试查询按钮tag
    let GRADE_EXAMINATION_BTN_TAG = 8
    
    // MARK: - 形势政策按钮
    var situationAndPolicyBtn = UIButton()
    
    // MARK: - 形势政策按钮tag
    let SITUATION_AND_POLICY_BTN_TAG = 9
    
    // MARK: - 考勤查询按钮
    var attendanceSearchingBtn: UIButton!
    
    // MARK: - 考勤查询按钮tag
    let ATTENDANCE_SEARCHING_BTN_TAG = 10
    
    // MARK: - 校历查询按钮
    var calendarBtn: UIButton!
    
    // MARK: - 校历查询按钮tag
    let CALENDAR_BTN_TAG = 11
    
    // MARK: - 电费查询按钮
    var electricityChargeSearchingBtn: UIButton!
    
    // MARK: - 电费查询按钮tag
    let ELECTRICITY_CHARGE_SEARCHING_BTN_TAG = 12
    
    // MARK: - 轮播图片url
    var imaginURLGroup = [URL]()
    
    // MARK: - 轮播图片数组
    var imageGroup = [UIImage]()
    
    // MARK: - 轮播图片标题数组
    var imageContentGroup = [String]()
    
    // MARK: - 轮播图片跳转url数组
    var redirectURLGroup = [URL]()
    
    // MARK: - 整个按钮尺寸
    let WIDTH = Int((SCREEN_WIDTH - 35) / 4)
    let HEIGHT = Int((SCREEN_WIDTH - 35) / 4)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.isScrollEnabled = false
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    // MARK: - 单元格高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.view.frame.height / 3
        case 1:
            return self.view.frame.height - self.view.frame.height / 3
        default:
            return 44
        }
    }
    
    // MARK: - 单元格间隔
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 15
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "default")
        switch indexPath.section {
        // MARK: - 图片轮播相关属性
        case 0:
            defaultCell?.selectionStyle = .none
            DispatchQueue.global().async {
                let requestUtil = BWRequestUtil.shareInstance
                requestUtil.sendRequestResponseJSON(BWApiurl.GET_SCROLL_FILE, method: .post, parameters: [:]){ response in
                    var responseData = JSON(data: response.data!)
                    
                    // 获取json失败
                    if(responseData == JSON.null){
                        SVProgressHUD.showError(withStatus: "服务器异常！")
                        let width = self.view.frame.width - 20
                        let height = self.view.frame.height / 3 - 10
                        var errorImageGroup = [UIImage]()
                        errorImageGroup.append(UIImage.init(named: "bg")!)
                        let scrollView = SDCycleScrollView(frame: CGRect(x:10, y:5, width: width, height: height), shouldInfiniteLoop: true, imageNamesGroup: errorImageGroup as [AnyObject])
                        scrollView?.delegate = self
                        self.view.addSubview(scrollView!)
                        return
                    }
                    
                    var datas = responseData["data"]
                    // 遍历json数组，将获取并解析的图片和图片标题追加入图片数组和图片标题数组
                    for i in 0..<(datas.count){
                        let imgUrlStr = datas[i]["imgUrl"].stringValue
                        let imgUrl = NSURL(string:imgUrlStr)
                        let imageData = NSData(contentsOf: imgUrl as! URL)
                        let image = UIImage(data: imageData as! Data)
                        let imgContent = datas[i]["content"].stringValue
                        let redirectUrlStr = datas[i]["redirectUrl"].stringValue
                        let redirectUrl = NSURL(string: redirectUrlStr)
                        self.redirectURLGroup.append(redirectUrl! as URL)
                        self.imaginURLGroup.append(imgUrl! as URL)
                        self.imageContentGroup.append(imgContent)
                        self.imageGroup.append(image!)
                    }
                    let width = self.view.frame.width
                    let height = self.view.frame.height / 3 - 10
                    let scrollView = SDCycleScrollView(frame: CGRect(x:0, y:10, width: width, height: height), shouldInfiniteLoop: true, imageNamesGroup: self.imageGroup as [AnyObject])
                    scrollView?.delegate = self
                    scrollView?.titlesGroup = self.imageContentGroup
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.view.addSubview(scrollView!)
                        
                    })
                }
            }
            return defaultCell!
            
        // MARK: - 按钮相关属性
        case 1:
            defaultCell?.selectionStyle = .none
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
            // MARK: - cell的标题
            let titleView = UIView(frame: CGRect(x: 0, y: 15, width: self.view.frame.width, height: 20))
            let titleLogoView = UIImageView(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
            let titleLogo = UIImage(named: "common")
            titleLogoView.image = titleLogo
            let titleLabel = UILabel(frame: CGRect(x: 25.0, y: 2.5, width: 100.0, height: 10.0))
            titleLabel.text = "常用功能"
            titleLabel.textColor = UIColor.darkGray
            titleLabel.font = UIFont.systemFont(ofSize: 11)
            titleView.addSubview(titleLogoView)
            titleView.addSubview(titleLabel)
            defaultCell?.addSubview(titleView)

            // 按钮的x坐标
            let btnX = 10
            // 按钮之间的间隔
            let btnYMargin = (Int(self.view.frame.height / 3) - WIDTH * 2) / 3
            // 按钮的y坐标
            let btnY = Int(self.view.frame.height / 3) + btnYMargin + 30
            
            // MARK: -  快递中心按钮相关属性
            expressBtn = UIButton(frame: CGRect(x:btnX, y:btnY, width:WIDTH, height:HEIGHT))
            setUpButton(expressBtn, title: "快递中心", imageStr: "express", tag: EXPRESS_BTN_TAG)
            
            // MARK: - 失物招领按钮相关属性
            lostAndFoundBtn = UIButton(frame: CGRect(x:btnX + WIDTH + 5, y:btnY, width:WIDTH, height:HEIGHT))
            setUpButton(lostAndFoundBtn, title: "失物招领", imageStr: "lostAndFound", tag: LOST_AND_FOUND_BTN_TAG)
            
            // MARK: - 跳蚤市场按钮相关属性
            fleaMarketBtn = UIButton(frame: CGRect(x:btnX + WIDTH + 5 + WIDTH + 5, y:btnY, width:WIDTH, height:HEIGHT))
            setUpButton(fleaMarketBtn, title: "跳蚤市场", imageStr: "fleaMarket", tag: FLEA_MARKET_BTN_TAG)
            
            // MARK: - 课程安排按钮相关属性
            curriculumScheduleBtn = UIButton(frame: CGRect(x:btnX + WIDTH + 5 + WIDTH + 5 + WIDTH + 5, y:btnY, width:WIDTH, height:HEIGHT))
            setUpButton(curriculumScheduleBtn, title: "课程安排", imageStr: "curriculum", tag: CURRICULUM_SCHEDULE_BTN_TAG)
            
            // MARK: - 分界线1
            let line1 = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height / 6 + 20, width: self.view.frame.size.width, height: 0.5))
            line1.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            defaultCell?.addSubview(line1)
            
            // MARK: - 成绩查询按钮相关属性
            scoreSearchingBtn = UIButton(frame: CGRect(x:btnX, y:btnY + WIDTH + btnYMargin, width:WIDTH, height:HEIGHT))
            setUpButton(scoreSearchingBtn, title: "成绩查询", imageStr: "score", tag: SCORE_SEARCHING_BTN_TAG)
            
            // MARK: - 考试查询按钮相关属性
            examinationSearchingBtn = UIButton(frame: CGRect(x:btnX + WIDTH + 5, y:btnY + WIDTH + btnYMargin, width:WIDTH, height:HEIGHT))
            setUpButton(examinationSearchingBtn, title: "考试查询", imageStr: "examination", tag: EXAMINATION_SEARCHING_BTN_TAG)
            
            // MARK: - 形势政策查询按钮相关属性
            situationAndPolicyBtn = UIButton(frame: CGRect(x:btnX + WIDTH + 5 + WIDTH + 5, y:btnY + WIDTH + btnYMargin, width:WIDTH, height:HEIGHT))
            setUpButton(situationAndPolicyBtn, title: "形势政策", imageStr: "situationAndPolicy", tag: SITUATION_AND_POLICY_BTN_TAG)
            
            // MARK: - 考勤查询按钮相关属性
            attendanceSearchingBtn = UIButton(frame: CGRect(x:btnX + WIDTH + 5 + WIDTH + 5 + WIDTH + 5, y:btnY + WIDTH + btnYMargin, width:WIDTH, height:HEIGHT))
            setUpButton(attendanceSearchingBtn, title: "考勤查询", imageStr: "attendance", tag: ATTENDANCE_SEARCHING_BTN_TAG)
            
            // MARK: - 分界线2
            let line2 = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height / 6 + CGFloat(HEIGHT) + CGFloat(btnYMargin) + 20, width: self.view.frame.size.width, height: 0.5))
            line2.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            defaultCell?.addSubview(line2)
            
            // MARK: - 校历查询按钮相关属性
            calendarBtn = UIButton(frame: CGRect(x: btnX, y: btnY + 2 * (WIDTH + btnYMargin), width: WIDTH, height: HEIGHT))
            setUpButton(calendarBtn, title: "校历查询", imageStr: "calendar", tag: CALENDAR_BTN_TAG)
            
            // MARK: - 等级考试查询按钮相关属性
            gradeExaminationBtn = UIButton(frame: CGRect(x: btnX + WIDTH + 5, y: btnY + 2 * (WIDTH + btnYMargin), width: WIDTH, height: HEIGHT))
            setUpButton(gradeExaminationBtn, title: "等级考试", imageStr: "gradeExamination", tag: GRADE_EXAMINATION_BTN_TAG)
            
            // MARK: - 电费查询按钮相关属性
            electricityChargeSearchingBtn = UIButton(frame: CGRect(x: btnX + 2 * (WIDTH + 5), y: btnY + 2 * (WIDTH + btnYMargin), width: WIDTH, height: HEIGHT))
            setUpButton(electricityChargeSearchingBtn, title: "电费查询", imageStr: "charge", tag: ELECTRICITY_CHARGE_SEARCHING_BTN_TAG)
            
            // MARK: - 图书馆按钮相关属性
            libraryBtn = UIButton(frame: CGRect(x: btnX + 3 * (WIDTH + 5), y: btnY + 2 * (WIDTH + btnYMargin), width: WIDTH, height: HEIGHT))
            setUpButton(libraryBtn, title: "图书馆", imageStr: "library", tag: LIBRARY_BTN_TAG)
            
            return defaultCell!
            
        default:
            return defaultCell!
            
        }
    }
    
    // MARK: - 设置按钮属性
    func setUpButton(_ button: UIButton, title: String, imageStr: String, tag: Int) {
        // 设置标题
        button.setTitle(title, for: UIControlState.normal)
        // 修改按钮图标尺寸
        let image = UIImage(named: imageStr)
        let resizedImage = image?.setImageSize(CGSize(width: WIDTH, height: HEIGHT))
        // 设置图标
        button.setImage(resizedImage, for: UIControlState.normal)
        // 设置按钮字体和大小
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
        // 设置按钮字体颜色
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        // 设置按钮图标和字体的位置
        let buttonImageSize:CGSize = (button.imageView?.frame.size)!
        let buttonTitleSize:CGSize = (button.titleLabel?.frame.size)!
        button.imageEdgeInsets = UIEdgeInsets(top: buttonTitleSize.height, left: 20, bottom: buttonTitleSize.height + 10, right: 20)
        button.titleEdgeInsets = UIEdgeInsets(top: -buttonTitleSize.height, left: -buttonImageSize.width, bottom: -buttonImageSize.height, right: 0)
        // 设置按钮tag
        button.tag = tag
        // 添加按钮监听
        button.addTarget(self, action: #selector(BWSquareTableViewController.buttonClicked(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    // MARK: - 按钮点击事件处理
    func buttonClicked(_ sender: UIButton){
        switch sender.tag {
            
        // 快递中心按钮点击事件处理
        case EXPRESS_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "expressViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 失物招领按钮点击事件处理
        case LOST_AND_FOUND_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "lostAndFound")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 跳蚤市场按钮点击事件处理
        case FLEA_MARKET_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "fleaMarketViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 成绩查询按钮点击事件处理
        case SCORE_SEARCHING_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "scoreSearchingViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 考试查询按钮点击事件处理
        case EXAMINATION_SEARCHING_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "examinationSearchingViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 校历查询按钮点击事件处理
        case CALENDAR_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "calendarViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 形势与政策按钮点击事件处理
        case SITUATION_AND_POLICY_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "situationAndPolicyViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 考勤查询按钮点击事件处理
        case ATTENDANCE_SEARCHING_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "attendanceViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 电费查询按钮点击事件处理
        case ELECTRICITY_CHARGE_SEARCHING_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "electricityViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 图书馆按钮点击事件处理
        case LIBRARY_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "libraryViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        
        // 等级考试按钮点击事件处理
        case GRADE_EXAMINATION_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "gradeExaminationViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        // 课程安排按钮点击事件处理
        case CURRICULUM_SCHEDULE_BTN_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "timetableViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
}

// MARK: - 实现BWSquareTableViewController的SDCycleScrollViewDelegate代理方法
extension BWSquareTableViewController:SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let bannerVC = self.storyboard?.instantiateViewController(withIdentifier: "bannerWebViewController") as! BWBannerWebViewController
        // 页面传参
        bannerVC.bannerContent = imageContentGroup[index]
        bannerVC.webViewURL = redirectURLGroup[index]
        // 页面跳转
        self.navigationController?.pushViewController(bannerVC, animated: true)
    }
}

