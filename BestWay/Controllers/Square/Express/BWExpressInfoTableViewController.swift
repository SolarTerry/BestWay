//
//  BWExpressInfoTableViewController.swift
//  BestWay
//
//  Created by solar on 17/1/21.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import SwiftyJSON

// 单个快递点页面控制器
class BWExpressInfoTableViewController: UITableViewController {
    
    // MARK: - 快递点信息简介view
    var expressIntroductionView = UIView()
    
    // MARK: - 快递点logo view
    var expressLogoView = UIImageView()
    
    // MARK: - 快递点logo
    var expressLogo = UIImage()
    
    // MARK: - 快递点信息label
    var expressInfoLabel = UILabel()
    
    // MARK: - 快递点id
    var expressId:Int!
    
    // MARK: - 快递点地址
    var expressAddress:String!
    
    // MARK: - 快递点名称
    var expressName:String!
    
    // MARK: - 快递点电话
    var expressPhone:String!
    
    // MARK: - 快递点开放时间
    var expressOpenTime:String!
    
    // MARK: - 快递点关闭时间
    var expressCloseTime:String!
    
    // MARK: - 当前页码
    var pageNow = 1
    
    // MARK: - 每页加载数
    let LIMIT = 5
    
    // MARK: - 用于记录是否是打开页面刷新
    var flag = true
    
    // MARK: - 用于记录是否是最后一条数据
    var isLast = false
    
    // MARK: - 包裹信息 0:待接单 1:已接单 2:已完成
    var expressInfoDetails: [Dictionary<String,String>] = []
    
    // MARK: - 新增快递信息按钮
    var addButton = UIButton()
    
    // MARK: - 新增快递信息按钮tag
    let ADD_BUTTON_TAG = 0
    
    // MARK: - 新增快递信息按钮y坐标
    var addButtonY = CGFloat()
    
    // MARK: - 帮代领按钮tag
    let HELP_BUTTON_TAG = 1
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        navigationController?.navigationBar.isTranslucent = false
        
        // MARK: - 设置新增快递信息按钮样式
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(BWExpressInfoTableViewController.addButtonClicked(_:)))
        
        // 获取全部订单信息
        getExpressData(pageNow: pageNow, limit: LIMIT)
        
        // 下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader()
        self.tableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(BWExpressInfoTableViewController.headerRefresh))
        
        // 上拉刷新
        self.tableView.mj_footer = MJRefreshAutoNormalFooter()
        self.tableView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(BWExpressInfoTableViewController.footerRefresh))
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
            return self.expressInfoDetails.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView.register(UINib(nibName:"BWIntroductionTableViewCell",bundle:nil), forCellReuseIdentifier: "IntroductionTableViewCell")
        let logoCell:BWIntroductionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "IntroductionTableViewCell") as! BWIntroductionTableViewCell
        self.tableView.register(UINib(nibName:"BWCardTableViewCell",bundle:nil), forCellReuseIdentifier: "CardTableViewCell")
        let infoCell:BWCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell") as! BWCardTableViewCell
        switch indexPath.section {
        case 0:
            return logoCell.frame.size.height
        case 1:
            return infoCell.frame.size.height
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 注册快递简介cell
        self.tableView.register(UINib(nibName:"BWIntroductionTableViewCell",bundle:nil), forCellReuseIdentifier: "IntroductionTableViewCell")
        let logoCell:BWIntroductionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "IntroductionTableViewCell") as! BWIntroductionTableViewCell
        // 注册快递信息cell
        self.tableView.register(UINib(nibName:"BWCardTableViewCell",bundle:nil), forCellReuseIdentifier: "CardTableViewCell")
        let infoCell:BWCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell") as! BWCardTableViewCell
        
        switch indexPath.section {
        // MARK: - 设置快递点信息属性
        case 0:
            logoCell.selectionStyle = .none
            logoCell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 4)
            expressIntroductionView.frame = logoCell.frame
            expressLogoView.frame = CGRect(x: 20, y: logoCell.frame.height / 2 - 50, width: 100, height: 100)
            expressLogoView.image = expressLogo
            expressInfoLabel.frame = CGRect(x: logoCell.frame.width / 3, y: 0, width: logoCell.frame.width * 2 / 3, height: logoCell.frame.height)
            
            // 使UILabel里的内容可以换行
            expressInfoLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            expressInfoLabel.numberOfLines = 0
            expressInfoLabel.text = "\n开放时间：\(expressOpenTime!)\n关闭时间：\(expressCloseTime!)\n联系电话：\(expressPhone!)"
            expressInfoLabel.font = UIFont(name: "GillSans-SemiBold", size: 15)
            expressInfoLabel.textColor = UIColor(red: 49/255, green: 151/255, blue: 230/255, alpha: 0.9)
            expressInfoLabel.textAlignment = NSTextAlignment.center
            
            expressIntroductionView.addSubview(expressInfoLabel)
            expressIntroductionView.addSubview(expressLogoView)
            
            self.tableView.addSubview(expressIntroductionView)
            return logoCell
            
        // MARK: - 设置快递订单属性
        case 1:
            infoCell.selectionStyle = .none
            
            if expressInfoDetails.isEmpty {
                return infoCell
            }else {
                let item = expressInfoDetails[indexPath.row]
                infoCell.backgroundImage.backgroundColor = UIColor.colorFromRGB(0xC6E2FF)
                infoCell.backgroundImage.layer.masksToBounds = true
                infoCell.backgroundImage.layer.cornerRadius = 8.0
                
                // 获取发布人头像
                let requestUtil = BWRequestUtil.shareInstance
                requestUtil.sendRequestResponseJSON(BWApiurl.getUerImageUrl(item["userName"]!), method: .post, parameters: [:], completionHandler: {
                    (response) in
                    if NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) != nil {
                        infoCell.userLogo.image = UIImage(named: "user-default-logo")
                        return
                    }
                    let userLogo = UIImage(data: response.data!)
                    infoCell.userLogo.image = userLogo
                })
                infoCell.userLogo.layer.masksToBounds = true
                infoCell.userLogo.layer.cornerRadius = infoCell.userLogo.frame.size.width / 2
                infoCell.userName.text = item["nickName"]
                infoCell.releaseTime.text = item["createTime"]
                infoCell.infoLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                infoCell.infoLabel.numberOfLines = 0
                infoCell.infoLabel.text = "\n目标地址：\(item["targetAddress"]!)\n备注：\(item["note"]!)\n佣金：\(item["bonusMoney"]!)元 \(item["paymentWay"]!)\n过期时间：\(item["closeTime"]!)"
                infoCell.button.setImage(UIImage(named: "help"), for: UIControlState.normal)
                infoCell.button.tag = indexPath.row
                infoCell.button.addTarget(self, action: #selector(BWExpressInfoTableViewController.helpButtonClick(_:)), for: UIControlEvents.touchUpInside)
                infoCell.status.image = UIImage(named: "unaccepted")
                
                return infoCell
            }

        default:
            return infoCell
        }
    }
    
    // MARK: - 按钮悬浮效果
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addButton.frame = CGRect(x: addButton.frame.origin.x, y: addButtonY + self.tableView.contentOffset.y, width: addButton.frame.width, height: addButton.frame.height)
    }
    
    // MARK: - 添加订单按钮点击处理方法
    func addButtonClicked(_ sender: UIButton){
BWExpressAddAlertView().showAlert(self.expressId){(OtherButton) -> Void in
            print("执行了确认")
        }
        print("点击了")
    }
    
    // MARK: - 帮代领按钮点击处理方法
    func helpButtonClick(_ sender: UIButton) {
        let item = expressInfoDetails[sender.tag]
        BWExpressHelpAlertView().showAlert(self.expressId, targetAddress: item["targetAddress"]!, bonusMoney: item["bonusMoney"]!, note: item["note"]!, closeTime: item["closeTime"]!, paymentWay: item["paymentWay"]!){(OtherButton) -> Void in
            print("执行了确认")
        }
    }
    
    // MARK: - 获取快递点有效订单
    func getExpressData(pageNow: Int, limit: Int){
        if self.flag {
            SVProgressHUD.show(withStatus: "正在加载...")
        }
        let parameters = ["siteId":expressId,"pageNow":pageNow,"limit":limit]
        let requestUtil = BWRequestUtil.shareInstance
        
        // 如果是上拉刷新，清空数组
        if pageNow == 1 {
            self.expressInfoDetails = []
        }

        requestUtil.sendRequestResponseJSON(BWApiurl.GET_SITE_ORDER_ALL, method: .post, parameters: parameters,completionHandler: { (response) in
            
            var responseData = JSON(data: response.data!)
            
            // 获取JSON失败
            if responseData == JSON.null {
                SVProgressHUD.showError(withStatus: "服务器异常！")
                return
            }
            
            // 解析JSON数据
            var datas = responseData["data"]
            if datas.count < 5 {
                self.isLast = true
            }
            for i in 0..<(datas.count) {
                let userName = datas[i]["masterUser"]["username"].stringValue
                let nickName = datas[i]["masterUser"]["nickname"].stringValue
                let id = datas[i]["id"].stringValue
                let targetAddress = datas[i]["targetAddress"].stringValue
                let note = datas[i]["note"].stringValue == "" ? "无":datas[i]["note"].stringValue
                let status = datas[i]["status"].stringValue
                let createTimeStamp = datas[i]["createTime"].stringValue
                let createTime = BWDateUtil.timeStampToYMDHMString(createTimeStamp)
                let closeTimeStamp = datas[i]["closeTime"].stringValue
                let closeTime = BWDateUtil.timeStampToYMDHMString(closeTimeStamp)
                let bonusMoney = datas[i]["bonusMoney"].stringValue
                let paymentWayCode = datas[i]["paymentWay"].stringValue
                var paymentWay = ""
                if paymentWayCode == "0" {
                    paymentWay = "微信支付"
                }else {
                    paymentWay = "货到付款"
                }
                let expressInfoDetail = ["id":id, "userName":userName,"nickName":nickName, "createTime":createTime, "targetAddress":targetAddress, "status":status, "note":note, "bonusMoney":bonusMoney, "paymentWay":paymentWay, "closeTime": closeTime]
                self.expressInfoDetails.append(expressInfoDetail)
            }
            
            // 更新数据
            self.tableView.reloadData()
            
            // 判断是否第一次进入此页面
            if self.flag {
                SVProgressHUD.showSuccess(withStatus: "加载完成！")
                self.flag = false
            }
        })
        
        // 加载完成，当前页面＋1
        self.pageNow += 1
    }

    // MARK: - 下拉刷新处理方法
    func headerRefresh() {
        self.pageNow = 1
        getExpressData(pageNow: self.pageNow, limit: LIMIT)
        isLast = false
        self.tableView.reloadData()
        print("header")
        self.tableView.mj_footer.resetNoMoreData()
        self.tableView.mj_header.endRefreshing()
    }
    
    // MARK: - 上拉刷新处理方法
    func footerRefresh() {
        getExpressData(pageNow: self.pageNow, limit: LIMIT)
        if isLast {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }else {
            self.tableView.reloadData()
            print("footer")
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
}
