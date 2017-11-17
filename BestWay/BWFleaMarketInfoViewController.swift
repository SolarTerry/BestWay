//
//  BWFleaMarketInfoViewController.swift
//  BestWay
//
//  Created by solar on 17/5/16.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SDCycleScrollView
import MJRefresh
import SVProgressHUD

// 单条跳蚤市场信息页面控制器
class BWFleaMarketInfoViewController: UIViewController {
    
    // MARK: - 轮播商品图片数组
    var imageArray = [UIImage]()
    
    // MARK: - 图片轮播view
    var scrollView: SDCycleScrollView!
    
    // MARK: - 图片轮播view高度
    let scrollViewHeight = CGFloat(400)
    
    // MARK: - 轮播商品图片cell的tag
    let SCROLL_IMAGE_TAG = 0
    
    // MARK: - 自定义导航栏
    var customBarView: UIView!
    
    // MARK: - 返回按钮
    var backButton: UIButton!
    
    // MARK: - 返回按钮tag
    let BACK_BUTTON_TAG = 1
    
    // MARK: - 更多功能按钮
    var moreButton: UIButton!
    
    // MARK: - 更多功能按钮tag
    let MORE_BUTTON_TAG = 2
    
    // MARK: - 更多功能选择弹窗
    var moreAlertController: UIAlertController!
    
    // MARK: - 被举报用户ID
    var reportedUser: String!
    
    // MARK: - 导航栏view
    var barView: UIView!
    
    // MARK: - 当导航栏显示出来时的返回按钮
    var barBackButton: UIButton!
    
    // MARK: - 当导航栏显示出来时的返回按钮tag
    let BAR_BACK_BUTTON = 3
    
    // MARK: - 当导航栏显示出来时的更多功能按钮
    var barMoreButton: UIButton!
    
    // MARK: - 当导航栏显示出来时的更多功能按钮tag
    let BAR_MORE_BUTTON = 4
    
    // MARK: - 联系他／她按钮
    var contectButton: UIButton!
    
    // MARK: - 联系他／她按钮tag
    let CONTECT_BUTTON_TAG = 3
    
    // MARK: - 底部工具栏
    var toolBar: UIToolbar!
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 标题
    var itemTitle: String!
    
    // MARK: - 价格
    var price: String!
    
    // MARK: - 商品描述
    var itemDescription: String!
    
    // MARK: - 用户头像
    var userLogoImage: UIImage!
    
    // MARK: - 用户名
    var username: String!
    
    // MARK: - 发布时间
    var time: String!
    
    // MARK: - 主storyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        // 隐藏导航栏
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 退出后显示导航栏
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 模拟数据
        self.itemTitle = "热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡热水卡"
        self.price = "30.0"
        self.itemDescription = "1abcdefghijklmnopqrstuvwxyz2abcdefghijklmnopqrstuvwxyz3abcdefghijklmnopqrstuvwxyz4abcdefghijklmnopqrstuvwxyz5abcdefghijklmnopqrstuvwxyz6abcdefghijklmnopqrstuvwxyz7abcdefghijklmnopqrstuvwxyz8abcdefghijklmnopqrstuvwxyz9abcdefghijklmnopqrstuvwxyz10abcdefghijklmnopqrstuvwxyz11abcdefghijklmnopqrstuvwxyz12abcdefghijklmnopqrstuvwxyz13abcdefghijklmnopqrstuvwxyz14abcdefghijklmnopqrstuvwxyz15abcdefghijklmnopqrstuvwxyz16abcdefghijklmnopqrstuvwxyz17abcdefghijklmnopqrstuvwxyz18abcdefghijklmnopqrstuvwxyz19abcdefghijklmnopqrstuvwxyz20abcdefghijklmnopqrstuvwxyz21abcdefghijklmnopqrstuvwxyz22abcdefghijklmnopqrstuvwxyz23abcdefghijklmnopqrstuvwxyz24abcdefghijklmnopqrstuvwxyz25abcdefghijklmnopqrstuvwxyz26abcdefghijklmnopqrstuvwxyz27abcdefghijklmnopqrstuvwxyz28abcdefghijklmnopqrstuvwxyz29abcdefghijklmnopqrstuvwxyz30abcdefghijklmnopqrstuvwxyz31abcdefghijklmnopqrstuvwxyz"
        self.imageArray = [UIImage.init(named: "bg")!, UIImage.init(named: "bg")!, UIImage.init(named: "bg")!, UIImage.init(named: "bg")!, UIImage.init(named: "bg")!, UIImage.init(named: "table")!]
        self.userLogoImage = UIImage.init(named: "bg")
        self.username = "hhhhh"
        self.time = "2017-1-1 16:00"
        
        // 初始化主界面
        initView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 初始化主界面
    func initView() {
        // 顶部按钮宽度
        let barButtonWidth = CGFloat(30)
        // 顶部按钮高度
        let barButtonHeight = CGFloat(30)
        
        // 返回按钮
        self.backButton = UIButton(frame: CGRect(x: 10, y: 25, width: barButtonWidth, height: barButtonHeight))
        self.backButton.tag = BACK_BUTTON_TAG
        self.backButton.setImage(UIImage.init(named: "back_blue"), for: UIControlState.normal)
        self.backButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        // 更多功能按钮
        self.moreButton = UIButton(frame: CGRect(x: SCREEN_WIDTH - barButtonWidth - 10, y: 25, width: barButtonWidth, height: barButtonHeight))
        self.moreButton.tag = MORE_BUTTON_TAG
        self.moreButton.setImage(UIImage.init(named: "table"), for: UIControlState.normal)
        self.moreButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        
        // 图片
        self.scrollView = SDCycleScrollView(frame: CGRect(x: 0, y: -400, width: SCREEN_WIDTH, height: 400), shouldInfiniteLoop: true, imageNamesGroup: imageArray)
        self.scrollView.delegate = self
        self.scrollView.contentMode = .scaleAspectFill
        self.scrollView.clipsToBounds = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 主tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 50))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsetsMake(scrollViewHeight, 0, 0, 0)
        self.tableView.addSubview(self.scrollView)
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        
        // 联系他／她按钮
        self.contectButton = UIButton(frame: CGRect(x: 10, y: 10, width: SCREEN_WIDTH - 20, height: 30))
        self.contectButton.tag = CONTECT_BUTTON_TAG
        self.contectButton.setTitle("联系他", for: .normal)
        self.contectButton.layer.cornerRadius = 5.0
        self.contectButton.backgroundColor = UIColor.colorFromRGB(0x1E90FF)
        self.contectButton.titleLabel?.textColor = UIColor.white
        
        // 底部工具栏
        self.toolBar = UIToolbar(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 50, width: SCREEN_WIDTH, height: 50))
        self.toolBar.addSubview(self.contectButton)
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.moreButton)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.toolBar)
        self.view.bringSubview(toFront: self.backButton)
        self.view.bringSubview(toFront: self.moreButton)
        
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
    
    // MARK: - 按钮监听方法
    func buttonClicked(sender: UIButton) {
        switch sender.tag {
        // 返回按钮
        case BACK_BUTTON_TAG:
            self.navigationController?.popViewController(animated: true)
        // 更多功能按钮
        case MORE_BUTTON_TAG:
            self.reportedUser = self.username
            self.present(moreAlertController, animated: true, completion: nil)
        default:
            return
        }
    }
    

    // MARK: - 用户头像点击监听
    func userLogoTapped(_ sender: UITapGestureRecognizer) {
        let cell = sender.self.view?.superview?.superview as! BWFleaMarketInfoTableViewCell
        let vc = storyBoard.instantiateViewController(withIdentifier: "userViewController") as! BWUserViewController
        vc.username = cell.usernameLabel.text!
        vc.userLogo = cell.userLogoImageView.image
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - BWFleaMarketInfoViewController的UITableViewDelegate、UITableViewDataSource代理方法实现
extension BWFleaMarketInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 注册cell
        tableView.register(UINib(nibName: "BWFleaMarketInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "fleaMarketInfoTableViewCell")
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "fleaMarketInfoTableViewCell") as! BWFleaMarketInfoTableViewCell
        
        // 将cell设置为不可选
        infoCell.selectionStyle = .none
        
        // 更新cell里的数据
        infoCell.reloadData(title: self.itemTitle, price: self.price, description: self.itemDescription, userLogo: self.userLogoImage, username: self.username, time: self.time)

        // 将头像设为可点击状态
        infoCell.userLogoImageView.isUserInteractionEnabled = true
        // 设置头像点击事件
        let userLogoTap = UITapGestureRecognizer(target: self, action: #selector(userLogoTapped(_:)))
        userLogoTap.numberOfTapsRequired = 1
        userLogoTap.numberOfTouchesRequired = 1
        infoCell.userLogoImageView.addGestureRecognizer(userLogoTap)
        
        return infoCell
    }
    
}

// MARK: - BWFleaMarketInfoViewController的SDCycleScrollViewDelegate代理方法实现
extension BWFleaMarketInfoViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        // 跳转到全屏大图展示页面
        let previewVC = BWImagePreviewViewController(images: imageArray, index: index)
        self.present(previewVC, animated: true, completion: nil)
    }
}
