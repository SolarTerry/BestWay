//
//  BWCalendarViewController.swift
//  BestWay
//
//  Created by solar on 17/5/8.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 校历查询控制器
class BWCalendarViewController: UIViewController {
    // MARK: - 校历webview
    var webView: UIWebView!
    
    // MARK: - 校历url
    var calendarURL: NSURL!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "校历查询"
        
        calendarURL = NSURL.init(string: "https://www.baidu.com")
        
        let request = URLRequest(url: calendarURL! as URL)
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        webView.loadRequest(request as URLRequest)
        // 允许缩放网页
        webView.scalesPageToFit = true
        
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
