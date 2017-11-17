//
//  BWBannerWebViewController.swift
//  BestWay
//
//  Created by solar on 17/1/17.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit

// 广场页面滚动窗口控制器
class BWBannerWebViewController: UIViewController {
    
    // MARK: - 广告展示WebView
    var webView = UIWebView()
    
    // MARK: - 广告标题
    var bannerContent:String!
    
    // MARK: - 广告网页url
    var webViewURL:URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化界面
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 隐藏tabbar
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - 初始化界面
    func initView(){
        self.navigationItem.title = bannerContent
        let request = URLRequest(url: webViewURL as URL)
        webView.loadRequest(request as URLRequest)
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        // 允许缩放网页
        webView.scalesPageToFit = true
        
        self.view.addSubview(webView)
    }
    
}
