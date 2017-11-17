//
//  SettingTableViewController.swift
//  BestWay
//
//  Created by 万志强 on 16/12/14.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
import SVProgressHUD

// 个人中心设置页面控制器
class BWSettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 改变背景色
        self.tableView.backgroundColor = UIColor(red: 0.96247226, green: 0.9624947906, blue: 0.9624827504, alpha: 1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        // 改变FooterView的颜色
        view.tintColor = UIColor(red: 0.96247226, green: 0.9624947906, blue: 0.9624827504, alpha: 1)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)

        switch indexPath.section {
        case 0:
            return defaultCell
        case 1:
            // 取消选中样式
            defaultCell.selectionStyle = .none
            // 文字居中
            defaultCell.textLabel?.textAlignment = .center
            defaultCell.textLabel?.text = "退出登录"
            return defaultCell
        default:
            defaultCell.backgroundColor = UIColor.clear
            return defaultCell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            let alertViewController = UIAlertController.alertControllerWithAction("提示", msg: "您确认退出登录吗？", actionTitle: "确认", action: { (UIAlertAction) in
                UserDefaults.standard.removeObject(forKey: "rcToken")
                UserDefaults.standard.removeObject(forKey: "BWUser")
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.removeObject(forKey: "userLogo")
                RCIM.shared().logout()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
                self.present(vc!, animated: true, completion: {
                    SVProgressHUD.showSuccess(withStatus: "退出成功")
                })
            })
            
            self.present(alertViewController, animated: true, completion: nil)
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
