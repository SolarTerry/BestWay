//
//  BWLostAndFoundViewController.swift
//  BestWay
//
//  Created by solar on 17/3/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import Alamofire
import SVProgressHUD

// 失物招领页面控制器
class BWLostAndFoundViewController: UIViewController {
    
    // MARK: - tableview里每一条信息的内容结构体
    struct data {
        // MARK: - 用户头像
        var userlogo: UIImage
        // MARK: - 用户名
        var username: String
        // MARK: - 发布时间
        var time: String
        // MARK: - 物品
        var item: String
        // MARK: - 联系电话
        var phone: String
        // MARK: - 备注
        var note:String
        // MARK: - 配图
        var pictures:[UIImage]
    }
    
    // MARK: - 模拟的tableView里的信息
    var lostDataArray = [
        data(userlogo: UIImage.init(named: "bg")!, username: "aaa", time: "2017-1-1 16:00", item: "校卡", phone: "13798977777", note: "ndaifaoiewfawion", pictures: [UIImage.init(named: "bg")!,UIImage.init(named: "add1.png")!]),
        data(userlogo: UIImage.init(named: "user")!, username: "bbb", time: "2017-1-1 15:00", item: "手机", phone: "13798945677", note: "ndaifaoiewfawionndaifaoiewfawion", pictures: []),
        data(userlogo: UIImage.init(named: "user")!, username: "ccc", time: "2017-1-1 14:00", item: "书包", phone: "13798945367", note: "ndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawion", pictures: [UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!]),
        data(userlogo: UIImage.init(named: "user")!, username: "ddd", time: "2017-1-1 11:00", item: "校卡", phone: "13798977777", note: "ndaifaoiewfawion", pictures: [UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "main")!,UIImage.init(named: "bg")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "danger")!])
    ]
    
    var foundDataArray = [
        data(userlogo: UIImage.init(named: "user")!, username: "eee", time: "2017-1-1 09:00", item: "手机", phone: "13798945366", note: "ndaifaoiewfawion", pictures: [UIImage.init(named: "bg")!,UIImage.init(named: "add1.png")!]),
        data(userlogo: UIImage.init(named: "user")!, username: "fff", time: "2017-1-1 12:00", item: "书包", phone: "13798963477", note: "ndaifaoiewfawionndaifaoiewfawion", pictures: []),
        data(userlogo: UIImage.init(named: "user")!, username: "ggg", time: "2017-1-1 11:40", item: "校卡", phone: "1379896457", note: "ndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawion", pictures: [UIImage.init(named: "add1.png")!,UIImage.init(named: "danger")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!]),
        data(userlogo: UIImage.init(named: "user")!, username: "hhh", time: "2017-1-1 18:00", item: "银行卡", phone: "13798977777", note: "ndaifaoiewfawion", pictures: [UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "main")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "bg")!])
    ]
    
    var segmentControl1: BWSegmentControl!
    
    // MARK: - segmentControl
    var segmentControl: BWSegmentControl!
    
    // MARK: - 发布新失物招领信息按钮
    var composeButton: UIBarButtonItem!
    
    // MARK: - 发布新失物招领信息按钮tag
    let COMPOSE_BUTTON_TAG = 0
    
    // MARK: - 丢了东西列表
    var lostTableView: UITableView!
    
    // MARK: - 丢了东西列表tag
    let LOST_TABLE_VIEW_TAG = 1
    
    // MARK: - 捡了东西列表
    var foundTableView: UITableView!
    
    // MARK: - 捡了东西列表tag
    let FOUND_TABLE_VIEW_TAG = 2
    
    // MARK: - 更多功能按钮tag
    let MORE_BUTTON_TAG = 1
    
    // MARK: - 左滑手势
    var swipeLeftGesture: UISwipeGestureRecognizer!
    
    // MARK: - 右滑手势
    var swipeRightGesture: UISwipeGestureRecognizer!
    
    // MARK: - 丢失页面当前页码
    var lostPageNow = 1
    
    // MARK: - 每页加载数
    let LIMIT = 5
    
    // MARK: - 用于记录是否是打开页面刷新
    var flag = true
    
    // MARK: - 用于记录是否是最后一条丢失数据
    var isLostLast = false
    
    // MARK: - 拾到页面当前页码
    var foundPageNow = 1
    
    // MARK: - 用于纪录是否是最后一条拾到数据
    var isFoundLast = false
    
    // MARK: - 更多功能选择弹窗
    var moreAlertController: UIAlertController!
    
    // MARK: - 主storyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - 被举报用户ID
    var reportedUser: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 初始化界面
        initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - 初始化界面
    func initView() {
        
        // MARK: - 设置navigationBar样式
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "失物招领"
        composeButton = UIBarButtonItem(title: "发布", style: UIBarButtonItemStyle.plain, target: self, action: #selector(buttonClicked(sender:)))
        self.navigationItem.rightBarButtonItem = composeButton
        composeButton.tag = COMPOSE_BUTTON_TAG
        
        var frame = CGRect(x: 10.0, y: 60.0, width: self.view.bounds.size.width - 20.0, height: 44.0)
        
        // FIXME: - 这里有bug，只能显示一个segment,iOS11则不会
        self.segmentControl1 = BWSegmentControl(frame: frame)
        self.segmentControl1.delegate = self
        self.segmentControl1.items = ["first", "second", "third", "fouth"]
        self.segmentControl1.showBridge(show: true, index: 1)
        self.segmentControl1.autoScrollWhenIndexChange = false
        // iOS11以下系统添加一个subview暂时处理这个bug
        if Double(UIDevice.current.systemVersion)! < 11.0 {
            self.view.addSubview(self.segmentControl1)
        }
        
        // MARK: - 设置segmentControl样式
        frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 20, width: self.view.bounds.size.width, height: 44.0)
        self.segmentControl = BWSegmentControl(frame: frame)
        self.segmentControl.delegate = self
        self.segmentControl.items = ["丢了东西", "捡了东西"]
        self.segmentControl.selectedIndex = 0
        self.segmentControl.autoAdjustWidth = false
        self.segmentControl.bounces = true
        self.view.addSubview(segmentControl)
    
        initLostTableView()
        
        // MARK: - 左滑手势
        self.swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(sender:)))
        self.swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        // MARK: - 右滑手势
        self.swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(sender:)))
        self.view.addGestureRecognizer(swipeRightGesture)
        
        // MARK: - 更多功能弹窗相关属性
        moreAlertController = UIAlertController(title: "请选择", message: "操作", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let reportAction = UIAlertAction(title: "举报这条信息", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) in self.reportAction()
        })
        self.moreAlertController.addAction(cancelAction)
        self.moreAlertController.addAction(reportAction)
    }
    
    // MARK: - 举报点击事件
    func reportAction() {
        let vc = storyBoard.instantiateViewController(withIdentifier: "reportTableViewController") as! BWReportTableViewController
        vc.reportedUserID = self.reportedUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadView() {
        super.loadView()
    }

    // MARK: - segmentControl控制页面转换
    func segmentControlSelected(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            initLostTableView()
        case 1:
            initFoundTableView()
        default:
            break
        }
    }
    
    // MARK: - 按钮处理方法
    func buttonClicked(sender: UIButton) {
        switch sender.tag {
        // MARK: - 发布按钮处理方法
        case COMPOSE_BUTTON_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "addLostAndFoundInfoViewController") as! BWAddLostAndFoundInfoViewController
            vc.type = self.segmentControl.selectedIndex
            self.present(vc, animated: true, completion: nil)
        // MARK: - 更多功能按钮处理方法
        case MORE_BUTTON_TAG:
            let cell = sender.superview?.superview as! BWLostAndFoundInfoTableViewCell
            self.reportedUser = cell.usernameLabel.text!
            self.present(moreAlertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - 初始化列表
    func initTable(_ tableView: UITableView, tag: Int) {
        // tableview的tag赋值
        tableView.tag = tag
        // 代理、数据源
        tableView.delegate = self
        tableView.dataSource = self
        // tableview样式
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.groupTableViewBackground
        // 设置cell的默认高度
        tableView.estimatedRowHeight = 44.0
        // 设置cell根据InfoTableViewCell高度而改变高度
        tableView.rowHeight = UITableViewAutomaticDimension
        // 添加进view
        self.view.addSubview(tableView)
    }
    
    // MARK: - 初始化丢了东西列表
    func initLostTableView() {
        self.lostTableView = UITableView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + self.segmentControl.frame.height + 20, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.height)! - self.segmentControl.frame.height - 20))
        
        // 初始化列表
        initTable(self.lostTableView, tag: LOST_TABLE_VIEW_TAG)

        // 下拉刷新
        self.lostTableView.mj_header = MJRefreshNormalHeader()
        self.lostTableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(self.lostHeaderRefresh))
        // 上拉刷新
        self.lostTableView.mj_footer = MJRefreshAutoNormalFooter()
        self.lostTableView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(self.lostFooterRefresh))
    }
    
    // MARK: - 初始化捡了东西列表
    func initFoundTableView() {
        self.foundTableView = UITableView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + self.segmentControl.frame.height + 20, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.height)! - self.segmentControl.frame.height - 20))
        
        // 初始化列表
        initTable(self.foundTableView, tag: FOUND_TABLE_VIEW_TAG)
        
        // 下拉刷新
        self.foundTableView.mj_header = MJRefreshNormalHeader()
        self.foundTableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(self.foundHeaderRefresh))
        
        // 上拉刷新
        self.foundTableView.mj_footer = MJRefreshAutoNormalFooter()
        self.foundTableView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(self.foundFooterRefresh))
    }
    
    // MARK: - 丢失列表上拉刷新方法
    func lostHeaderRefresh() {
        self.lostPageNow = 1
        isLostLast = false
        getTableViewData(tableViewTag: LOST_TABLE_VIEW_TAG, pageNow: self.lostPageNow, limit: self.LIMIT)
        
        self.lostTableView.reloadData()
        //self.lostTableView.mj_footer.resetNoMoreData()
        self.lostTableView.mj_header.endRefreshing()
    }
    
    // MARK: - 丢失列表下拉刷新方法
    func lostFooterRefresh() {
        getTableViewData(tableViewTag: LOST_TABLE_VIEW_TAG, pageNow: self.lostPageNow, limit: LIMIT)
        if isLostLast {
            self.lostTableView.mj_footer.endRefreshingWithNoMoreData()
        }else {
            self.lostTableView.reloadData()
            self.lostTableView.mj_footer.endRefreshing()
        }
    }
    
    // MARK: - 拾到列表上拉刷新方法
    func foundHeaderRefresh() {
        self.foundPageNow = 1
        getTableViewData(tableViewTag: FOUND_TABLE_VIEW_TAG, pageNow: self.foundPageNow, limit: LIMIT)
        isFoundLast = false
        self.foundTableView.reloadData()
        self.foundTableView.mj_header.endRefreshing()
    }
    
    // MARK: - 拾到列表下拉刷新方法
    func foundFooterRefresh() {
        getTableViewData(tableViewTag: FOUND_TABLE_VIEW_TAG, pageNow: self.foundPageNow, limit: LIMIT)
        if isFoundLast {
            self.foundTableView.mj_footer.endRefreshingWithNoMoreData()
        }else {
            self.foundTableView.reloadData()
            self.foundTableView.mj_footer.endRefreshing()
        }
    }
    
    // TODO: - 获取失物招领列表信息
    func getTableViewData(tableViewTag: Int, pageNow: Int, limit: Int) {
        if tableViewTag == LOST_TABLE_VIEW_TAG {
            self.lostDataArray.append(contentsOf: lostDataArray)
            self.lostPageNow += 1
            if self.lostPageNow == 2 {
                self.isLostLast = true
            }
        } else {
            self.foundDataArray.append(contentsOf: lostDataArray)
            self.foundPageNow += 1
            if self.foundPageNow == 3 {
                self.isLostLast = true
            }
        }
    }
    
    // MARK: - 用户头像点击监听
    func userLogoTapped(_ sender: UITapGestureRecognizer) {
        let cell = sender.self.view?.superview?.superview as! BWLostAndFoundInfoTableViewCell
        let vc = storyBoard.instantiateViewController(withIdentifier: "userViewController") as! BWUserViewController
        vc.username = cell.usernameLabel.text!
        vc.userLogo = cell.userLogoImageView.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - BWLostAndFoundViewController的UITableViewDelegate、UITableViewDataSource代理方法实现
extension BWLostAndFoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView.tag {
        case 1:
            return self.lostDataArray.count
        case 2:
            return self.foundDataArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 注册cell
        tableView.register(UINib(nibName: "BWLostAndFoundInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        let cell: BWLostAndFoundInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! BWLostAndFoundInfoTableViewCell
        // 将cell设为不可点击状态
        cell.selectionStyle = .none
        // 设置cell的大小
        cell.frame = tableView.bounds
        
        // 将头像设为圆形
        cell.userLogoImageView.layer.masksToBounds = true
        cell.userLogoImageView.layer.cornerRadius = cell.userLogoImageView.frame.size.width / 2
        
        // 将头像设为可点击状态
        cell.userLogoImageView.isUserInteractionEnabled = true
        // 设置头像点击事件
        let userLogoTap = UITapGestureRecognizer(target: self, action: #selector(userLogoTapped(_:)))
        userLogoTap.numberOfTapsRequired = 1
        userLogoTap.numberOfTouchesRequired = 1
        cell.userLogoImageView.addGestureRecognizer(userLogoTap)
        
        // 更多功能按钮设置
        cell.moreButton.setBackgroundImage(UIImage.init(named: "more"), for: UIControlState.normal)
        cell.moreButton.tag = MORE_BUTTON_TAG
        cell.moreButton.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.layoutIfNeeded()
        
        switch tableView.tag {
        // MARK: - 丢失物品列表
        case 1:
            cell.reloadData(tableViewType: 1, userLogoImage: lostDataArray[indexPath.section].userlogo, username: lostDataArray[indexPath.section].username, time: lostDataArray[indexPath.section].time, item: lostDataArray[indexPath.section].item, phone: lostDataArray[indexPath.section].phone, note: lostDataArray[indexPath.section].note, pictures: lostDataArray[indexPath.section].pictures)
            return cell
        // MARK: - 拾到物品列表
        case 2:
            cell.reloadData(tableViewType: 2, userLogoImage: foundDataArray[indexPath.section].userlogo, username: foundDataArray[indexPath.section].username, time: foundDataArray[indexPath.section].time, item: foundDataArray[indexPath.section].item, phone: foundDataArray[indexPath.section].phone, note: foundDataArray[indexPath.section].note, pictures: foundDataArray[indexPath.section].pictures)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - BWLostAndFoundViewController的UIActionSheetDelegate代理方法实现
extension BWLostAndFoundViewController: UIActionSheetDelegate {
    // MARK: - 滑动手势处理方法
    func swipeGestureHandler(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        // MARK: - 左滑手势
        case UISwipeGestureRecognizerDirection.left:
            self.segmentControl.selectedIndex = 1
            initLostTableView()
            self.segmentControl.move(to: 1)
        // MARK: - 右滑手势
        case UISwipeGestureRecognizerDirection.right:
            self.segmentControl.selectedIndex = 0
            initFoundTableView()
            self.segmentControl.move(to: 0)
        default:
            self.segmentControl.selectedIndex = 1
            initLostTableView()
            self.segmentControl.move(to: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}

// MARK: - BWLostAndFoundViewController的BWSegmentControlDelegate代理方法实现
extension BWLostAndFoundViewController : BWSegmentControlDelegate {
    // MARK: - 选中segment代理方法
    func didSelected(segement: BWSegmentControl, index: Int) {
        segmentControlSelected(selectedIndex: index)
        segement.showBridge(show: false, index: index)
    }
}
