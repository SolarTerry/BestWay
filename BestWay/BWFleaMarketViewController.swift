//
//  BWFleaMarketViewController.swift
//  BestWay
//
//  Created by solar on 17/5/14.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
// 跳蚤市场页面控制器
class BWFleaMarketViewController: UIViewController {
    // MARK: - collectionView里每一条信息的内容结构题
    struct data {
        // 商品ID
        var itemID: String
        // 物品名称
        var item: String
        // 配图
        var picture: UIImage
        // 价格
        var price: String
    }
    
    // MARK: - 商品数据
    var dataArray = [
        data(itemID:"1", item: "手机", picture: UIImage.init(named: "bg")!, price: "1000"),
        data(itemID:"2", item: "书包", picture: UIImage.init(named: "bg")!, price: "50"),
        data(itemID:"3", item: "热水卡", picture: UIImage.init(named: "bg")!, price: "30"),
        data(itemID:"4", item: "手机", picture: UIImage.init(named: "bg")!, price: "1000"),
        data(itemID:"5", item: "书包", picture: UIImage.init(named: "bg")!, price: "50"),
        data(itemID:"6", item: "热水卡", picture: UIImage.init(named: "bg")!, price: "30"),
        data(itemID:"7", item: "手机九成新九成新九成新手机九成新九成新九成新", picture: UIImage.init(named: "bg")!, price: "1000"),
        data(itemID:"8", item: "书包", picture: UIImage.init(named: "bg")!, price: "50"),
        data(itemID:"9", item: "热水卡", picture: UIImage.init(named: "bg")!, price: "30"),
        data(itemID:"10", item: "手机", picture: UIImage.init(named: "bg")!, price: "1000"),
        data(itemID:"11", item: "书包", picture: UIImage.init(named: "bg")!, price: "50"),
        data(itemID:"12", item: "热水卡", picture: UIImage.init(named: "bg")!, price: "30")
    ]
    
    // MARK: - 发布按钮
    var composeButton: UIBarButtonItem!
    
    // MARK: - 发布按钮tag
    let COMPOSE_BUTTON_TAG = 1
    
    // MARK: - 主collectionview
    var collectionView: UICollectionView!
    
    // MARK: - 每页加载数
    let LIMIT = 5
    
    // MARK: - 当前页码
    var pageNow = 1
    
    // MARK: - 用于记录是否是打开页面刷新
    var flag = true
    
    // MARK: - 用于记录是否是最后一条数据
    var isLast = false
    
    // MARK: - 主storyboard
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // 发布按钮
        self.composeButton = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(buttonClicked(sender:)))
        self.composeButton.tag = COMPOSE_BUTTON_TAG
        self.navigationItem.rightBarButtonItem = self.composeButton
        
        // cell的宽度
        let itemWidth = (SCREEN_WIDTH - 10 - 5) / 2
        
        // cell的高度
        let itemHeight = (SCREEN_HEIGHT - (self.navigationController?.navigationBar.frame.size.height)! - 20 - 5 - 5 - 5 - 5) / 2
        
        // 初始化collectionview的layout
        let layout = UICollectionViewFlowLayout()
        
        // FIXME: - 设置cell的行间距（其实正常不适这样设置的，但是layout.minimumLineSpacing不知道为什么不生效）
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0)
        
        // 设置cell的列间距
        layout.minimumInteritemSpacing = 5
        
        // 设置cell的size
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        // 初始化collectionview
        self.collectionView = UICollectionView(frame: CGRect(x: 5, y: 0, width: SCREEN_WIDTH - 10, height: SCREEN_HEIGHT - (self.navigationController?.navigationBar.frame.size.height)! + 20), collectionViewLayout: layout)
        
        // 为collectionview注册cell
        self.collectionView.register(UINib(nibName: "BWFleaMarketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "fleaMarketCollectionViewCell")
        
        // collectionview的数据源和代理
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // collectionview的背景色
        self.collectionView.backgroundColor = UIColor.white
        
        // 获取全部信息
        
        // 下拉刷新
        self.collectionView.mj_header = MJRefreshNormalHeader()
        self.collectionView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        
        // 上拉刷新
        self.collectionView.mj_footer = MJRefreshAutoNormalFooter()
        self.collectionView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        
        self.view.addSubview(self.collectionView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 将导航栏显示出来
        self.navigationController?.isNavigationBarHidden = false
        // 设置导航栏标题
        self.navigationItem.title = "跳蚤市场"
        // 设置导航栏为非透明
        self.navigationController?.navigationBar.isTranslucent = false
        // 隐藏tabbar
        self.tabBarController?.tabBar.isHidden = true 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 设置导航栏为透明
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 按钮点击处理事件
    func buttonClicked(sender: UIButton) {
        switch sender.tag {
        // 发布按钮
        case COMPOSE_BUTTON_TAG:
            let vc = storyBoard.instantiateViewController(withIdentifier: "addFleaMarketViewController") as! BWAddFleaMarketViewController
            self.present(vc, animated: true, completion: nil)
        default:
            return
        }
    }
    
    // MARK: - 获取二手商品信息
    func getData(pageNow: Int, limit: Int) {
        // 判断是否第一次进入此页面
        if self.flag {
            SVProgressHUD.showSuccess(withStatus: "加载完成！")
            self.flag = false
        }
        // 模拟数据更新
        if self.pageNow == 2 {
            self.dataArray.append(contentsOf: dataArray)
        }else {
            self.isLast = true
        }
        // 加载完成，当前页面＋1
        self.pageNow += 1
    }
    
    // MARK: - 下拉刷新处理方法
    func headerRefresh() {
        self.pageNow = 1
        getData(pageNow: self.pageNow, limit: LIMIT)
        isLast = false
        self.collectionView.reloadData()
        self.collectionView.mj_footer.resetNoMoreData()
        self.collectionView.mj_header.endRefreshing()
    }
    
    // MARK: - 上拉刷新处理方法
    func footerRefresh() {
        getData(pageNow: self.pageNow, limit: LIMIT)
        if isLast {
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
        }else {
            self.collectionView.reloadData()
            self.collectionView.mj_footer.endRefreshing()
        }
    }

}
// BWFleaMarketViewController的UICollectionViewDelegate、UICollectionViewDataSource的代理方法
extension BWFleaMarketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell重用
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fleaMarketCollectionViewCell", for: indexPath) as! BWFleaMarketCollectionViewCell
        // 商品首张图片
        cell.imageView.image = dataArray[indexPath.row].picture
        // 商品价格
        cell.priceLabel.text = "￥: \(dataArray[indexPath.row].price) 元"
        // 商品标题
        cell.titleLabel.text = dataArray[indexPath.row].item
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.backgroundColor = UIColor.colorFromRGB(0x1E90FF).withAlphaComponent(CGFloat(0.2))
        cell.titleLabel.textColor = UIColor.darkGray
        // cell边框
        cell.layer.cornerRadius = 5.0
        
        return cell
    }
    
    // cell点击回调方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "fleaMarketInfoViewController") as! BWFleaMarketInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
