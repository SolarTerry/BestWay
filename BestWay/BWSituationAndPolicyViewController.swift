//
//  BWSituationAndPolicyViewController.swift
//  BestWay
//
//  Created by solar on 17/5/21.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 形势与政策页面控制器

// MARK: - 本周形势与政策结构体
struct situationAndPolicy {
    // 讲座题目
    var title: String!
    // 主讲教师
    var teacher: String!
    // 时间
    var time: String!
    // 地点
    var place: String!
}
class BWSituationAndPolicyViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 本周形势与政策信息数组
    var situationAndPolicyArray: [situationAndPolicy] = []
    
    // MARK: - 有效次数
    var count: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        // 显示导航栏
        self.navigationController?.isNavigationBarHidden = false
        // 导航栏标题
        self.navigationItem.title = "形势与政策"
        // 隐藏tabbar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - 主stroyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 模拟数据
        self.situationAndPolicyArray = [
            situationAndPolicy(title: "珠海社科普及月系列：金山银山与绿水青山——当前我国推进“绿色发展”面临的问题与对策", teacher: "赵华安", time: "5月15日(星期一)19:00-20:30", place: "励耘楼A111"),
            situationAndPolicy(title: "军工记忆(5、6集)", teacher: "无", time: "5月16日(星期二)19:00-20:30", place: "励耘楼A111"),
            situationAndPolicy(title: "社会主义核心价值观系列:自由的向度", teacher: "田仲勋", time: "5月17日(星期三)19:00-20:30", place: "励耘楼A111"),
            situationAndPolicy(title: "要为真理而斗争——从《国际歌》到《人民的名义》", teacher: "殷安阳", time: "5月18日(星期四)19:00-20:30", place: "励耘楼A112"),
            situationAndPolicy(title: "世界聚焦——“一带一路”高峰论坛的八大议题", teacher: "唐士奇", time: "5月18日(星期四)19:00-20:30", place: "励耘楼A111")
        ]
        //self.situationAndPolicyArray = []
        self.count = 3
        
        // 主tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + (self.navigationController?.navigationBar.frame.size.height)!))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        // 设置cell的默认高度
        self.tableView.estimatedRowHeight = 30
        // 设置cell根据BWScoreTableViewCell高度而改变高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.situationAndPolicyArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let reuseIdentifier = "cell"
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            // 有效次数label
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: (cell?.frame.height)!))
            label.text = "有效次数："
            label.textColor = UIColor.darkGray
            label.font = UIFont.systemFont(ofSize: 14)
            // 显示有效次数的label
            let countLabel = UILabel(frame: CGRect(x: 110, y: 0, width: 30, height: (cell?.frame.height)!))
            countLabel.text = "\(self.count!)"
            countLabel.textColor = MAIN_COLOR
            countLabel.font = UIFont.systemFont(ofSize: 14)
            
            cell?.addSubview(label)
            cell?.addSubview(countLabel)
            
            return cell!
        default:
            // 判断本周形势与政策信息数组是否为空
            if self.situationAndPolicyArray.isEmpty {
                // 数组为空的情况
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                let reuseIdentifier = "cell"
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
                cell?.selectionStyle = .none
                let label = UILabel(frame: (cell?.frame)!)
                label.textAlignment = .center
                label.text = "暂无本周形势与政策信息"
                cell?.addSubview(label)
                return cell!
            }else {
                // 数组非空则注册BWSituationAndPolicyTableViewCell
                tableView.register(UINib(nibName: "BWSituationAndPolicyTableViewCell", bundle: nil), forCellReuseIdentifier: "situationAndPolicyTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "situationAndPolicyTableViewCell") as! BWSituationAndPolicyTableViewCell
                cell.selectionStyle = .none
                // 给BWSituationAndPolicyTableViewCell各label赋值
                let title = self.situationAndPolicyArray[indexPath.section - 1].title
                let teacher = self.situationAndPolicyArray[indexPath.section - 1].teacher
                let time = self.situationAndPolicyArray[indexPath.section - 1].time
                let place = self.situationAndPolicyArray[indexPath.section - 1].place
                cell.reloadData(title: title!, teacher: teacher!, time: time!, place: place!)
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // 点击有效次数页面跳转
            let vc = storyBoard.instantiateViewController(withIdentifier: "situationAndPolicyDetailViewController") as! BWSituationAndPolicyDetailViewController
            vc.count = self.count!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
