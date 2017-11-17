//
//  BWSingleLostAndFoundViewController.swift
//  BestWay
//
//  Created by solar on 17/5/13.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit

// 单个用户失物招领控制器
class BWSingleLostAndFoundViewController: UIViewController {
    
    // MARK: - tableview里每一条信息的内容结构体
    struct data {
        // MARK: - 信息类别
        var type: Int
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
    var dataArray = [
        data(type: 0, time: "2017-1-1 16:00", item: "校卡", phone: "13798977777", note: "ndaifaoiewfawion", pictures: [UIImage.init(named: "bg")!,UIImage.init(named: "add1.png")!]),
        data(type: 0, time: "2017-1-1 14:00", item: "书包", phone: "13798945367", note: "ndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawion", pictures: [UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!]),
        data(type: 1, time: "2017-1-1 11:40", item: "校卡", phone: "1379896457", note: "ndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawionndaifaoiewfawion", pictures: [UIImage.init(named: "add1.png")!,UIImage.init(named: "danger")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!,UIImage.init(named: "add1.png")!]),
        data(type: 0, time: "2017-1-1 16:00", item: "校卡", phone: "13798977777", note: "", pictures: [UIImage.init(named: "bg")!,UIImage.init(named: "add1.png")!])
    ]
    
    // MARK: - 主tableview
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 初始化界面
    func initView() {
        // MARK: - 设置navigationBar样式
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "他的失物招领"
        
        // MARK: - 初始化列表
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (self.navigationController?.navigationBar.frame.height)!))
        self.tableView.register(UINib(nibName: "BWSingleLostAndFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "singleLostAndFound")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 设置cell的默认高度
        self.tableView.estimatedRowHeight = 44.0
        // 设置cell根据InfoTableViewCell高度而改变高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        
        self.view.addSubview(tableView)
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

extension BWSingleLostAndFoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BWSingleLostAndFoundTableViewCell = tableView.dequeueReusableCell(withIdentifier: "singleLostAndFound") as! BWSingleLostAndFoundTableViewCell
        cell.selectionStyle = .none
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        cell.reloadData(type: dataArray[indexPath.section].type, time: dataArray[indexPath.section].time, item: dataArray[indexPath.section].item, phone: dataArray[indexPath.section].phone, note: dataArray[indexPath.section].note, pictures: dataArray[indexPath.section].pictures)
        return cell
    }
}
