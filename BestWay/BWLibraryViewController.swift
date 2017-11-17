//
//  BWLibraryViewController.swift
//  BestWay
//
//  Created by solar on 17/5/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 图书馆页面控制器
class BWLibraryViewController: UIViewController {
    // MARK: - 图书馆webview
    var webView: UIWebView!
    
    // MARK: - 图书馆URL
    var libraryURL: NSURL!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "图书馆"
        
        libraryURL = NSURL.init(string: "http://lib.bnuz.edu.cn:8080/")
        
        let request = URLRequest(url: libraryURL! as URL)
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        webView.loadRequest(request as URLRequest)
        // 允许缩放网页
        webView.scalesPageToFit = true
        
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
