//
//  BWSituationAndPolicyDetailViewController.swift
//  BestWay
//
//  Created by solar on 17/5/22.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 用户形势与政策详细信息页面控制器
class BWSituationAndPolicyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 有效次数
    var count: Int!
    
    // MARK: - 提示view
    var tipsView: UIView!
    
    // MARK: - 主tableview
    var tableView: UITableView!
    
    // MARK: - 有效的形势与政策
    var situationAndPolicyArray: [situationAndPolicy] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "我的形势与政策"
    }

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
        
        // 提示view
        self.tipsView = UIView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + 20, width: SCREEN_WIDTH, height: 30))
        // 提示label
        let tipsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tipsView.frame.size.width, height: self.tipsView.frame.size.height))
        tipsLabel.text = "数据最终以政治教育中心数据为准"
        tipsLabel.textAlignment = .center
        tipsLabel.textColor = MAIN_COLOR
        tipsLabel.backgroundColor = UIColor.groupTableViewBackground
        tipsLabel.font = UIFont.systemFont(ofSize: 14)
        self.tipsView.addSubview(tipsLabel)
        
        // 主tableview
        self.tableView = UITableView(frame: CGRect(x: 0, y: self.tipsView.frame.size.height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.tipsView.frame.size.height))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        // 设置cell的默认高度
        self.tableView.estimatedRowHeight = 30
        // 设置cell根据BWScoreTableViewCell高度而改变高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.tipsView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 判断形势与政策有效信息数组是否为空
        if self.situationAndPolicyArray.isEmpty {
            return 1
        }else {
            return self.count!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 判断形势与政策有效信息数组是否为空
        if self.situationAndPolicyArray.isEmpty {
            return 0
        }else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 判断形势与政策有效信息数组是否为空
        if self.situationAndPolicyArray.isEmpty {
            // 数组为空的情况
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let reuseIdentifier = "cell"
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (cell?.frame.height)!))
            label.text = "你还没有听过形势与政策好吗"
            label.textAlignment = .center
            label.textColor = MAIN_COLOR
            cell?.addSubview(label)
            return cell!
        }else {
            // 数组非空就注册BWSituationAndPolicyTableViewCell
            tableView.register(UINib(nibName: "BWSituationAndPolicyTableViewCell", bundle: nil), forCellReuseIdentifier: "situationAndPolicyTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "situationAndPolicyTableViewCell") as! BWSituationAndPolicyTableViewCell
            cell.selectionStyle = .none
            // 给BWSituationAndPolicyTableViewCell的各label赋值
            let title = self.situationAndPolicyArray[indexPath.section].title
            let teacher = self.situationAndPolicyArray[indexPath.section].teacher
            let time = self.situationAndPolicyArray[indexPath.section].time
            let place = self.situationAndPolicyArray[indexPath.section].place
            cell.reloadData(title: title!, teacher: teacher!, time: time!, place: place!)
            
            return cell
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
