//
//  AppDelegate.swift
//  BestWay
//
//  Created by 万志强 on 16/10/30.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
import SwiftyJSON
import Reachability
import SVProgressHUD
import UserNotifications
import SafariServices

// MARK: - 屏幕宽度
let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width

// MARK: - 屏幕高度
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height

// MARK: - 主题色
let MAIN_COLOR = UIColor.colorFromRGB(0x1E90FF)

// MARK: - 用户坐标
var userLocation = CLLocationCoordinate2D()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var reach: Reachability?
    var user:BWUser?
    var pushToken = ""
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    
    // MARK: - 高德地图API KEY
    let amapApiKey = ""
    
    // MARK: - 禁止横屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        RCIM.shared().initWithAppKey("")
        RCIM.shared().userInfoDataSource = self
        
        // MARK: - 设置监听连接状态
        RCIM.shared().connectionStatusDelegate = self
        // MARK: - 设置消息接收的监听
        RCIM.shared().receiveMessageDelegate = self
        
        // MARK: - 通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                      categories: nil)
        if ((UIDevice.current.systemVersion as NSString).floatValue >= 8.0) {
            // MARK: - 可以添加自定义categories
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
            application.registerUserNotificationSettings(userSettings)
        }
        else {
            // MARK: - categories 必须为nil
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
            application.registerUserNotificationSettings(userSettings)
        }
        
        // MARK: - 启动JPushSDK
        JPUSHService.setup(withOption: nil, appKey: "",
                           channel: "Publish Channel", apsForProduction: false)
        
        AMapServices.shared().apiKey = amapApiKey
        
        // MARK: - 延长启动界面的停留时间
//        Thread.sleep(forTimeInterval: 2)
        
        // MARK: - 设置SVProgressHUD样式
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        
        // MARK: - 判断是否已经登录，登录过则跳过登陆界面
        let username = UserDefaults.standard.string(forKey: "username")
        if username != nil {
            let mainViewController = self.storyBoard.instantiateViewController(withIdentifier: "mainViewController")
            self.window?.rootViewController = mainViewController
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("wwww")
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error:\(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)

        
//        pushToken = deviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
//        print(pushToken)
//        UserDefaults.standard.set(pushToken, forKey: "pushToken")
//        RCIMClient.shared().setDeviceToken(pushToken)
        
        pushToken = deviceToken.description
        pushToken = pushToken.replacingOccurrences(of: "<", with: "")
        pushToken = pushToken.replacingOccurrences(of: ">", with: "")
        pushToken = pushToken.replacingOccurrences(of: " ", with: "")
        
        RCIMClient.shared().setDeviceToken(pushToken)
        
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // MARK: - 增加IOS 7的支持
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        RCIMClient.shared().recordRemoteNotificationEvent(userInfo)
        let pushServiceData = RCIMClient.shared().getPushExtra(fromRemoteNotification: userInfo)
        if pushServiceData != nil {
            print("received remote notification")
            print(pushServiceData!)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case "share":
            let items = ["hello 3D Touch"]
            let activityVC = UIActivityViewController(
                activityItems: items,
                applicationActivities: nil)
            self.window?.rootViewController?.present(activityVC, animated: true, completion: { () -> Void in
                
            })
        case "aboutUs":
            let vc = SFSafariViewController(url: URL(string:"http://terrylovesolar.com/")! as URL)
            self.window?.rootViewController?.present(vc, animated: true, completion: { () -> Void in
                
            })
        default:
            break
        }
    }
}

// MARK: - RCIMReceiveMessageDelegate扩展
extension AppDelegate: RCIMReceiveMessageDelegate {
    /*!
     接收消息的回调方法
     
     @param message     当前接收到的消息
     @param left        还剩余的未接收的消息数，left>=0
     
     @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
     其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
     您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
     */
    public func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if (left != 0) {
            print("收到一条消息，当前的接收队列中还剩余\(left)条消息未接收，您可以等待left为0时再刷新UI以提高性能")
        } else {
            print("收到一条消息")
        }
    }
}

// MARK: - RCIMConnectionStatusDelegate扩展
extension AppDelegate: RCIMConnectionStatusDelegate {
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        print("RCConnectionStatus = \(status.rawValue)")
    }
}

// MARK: - RCIMUserInfoDataSource扩展
extension AppDelegate: RCIMUserInfoDataSource {
    // MARK: - 融云获取用户信息方法
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        let requestUtil = BWRequestUtil.shareInstance
        let userData = UserDefaults.standard.data(forKey: "BWUser\(userId!)")
        
        // MARK: - 尝试从本地获取用户信息
        if userData != nil {
            self.user = (NSKeyedUnarchiver.unarchiveObject(with: userData!) as! BWUser)
            let userInfo = RCUserInfo()
            userInfo.userId = userId!
            userInfo.portraitUri = BWApiurl.getUerImageUrl(userId!)
            userInfo.name = user?.nickname
            return completion(userInfo)
        } else {
            requestUtil.sendRequestResponseJSON(BWApiurl.GET_FRIEND_INFO, method: .post, parameters: ["userId":userId]) { response in
                var data = JSON(data: response.data!)
                if data == JSON.null {
                    return
                }
                var info = data["data"]
                
                // MARK: - 返回的Message信息
                let message = data["message"].stringValue
                
                // MARK: - 返回的Code
                let code = data["code"].intValue
                
                switch code {
                case 0:
                    // MARK: - 解析出JSON中信息
                    let id = info["id"].intValue
                    let realName = info["realName"].stringValue
                    let password = info["password"].stringValue
                    let nickname = info["nickname"].stringValue
                    let college = info["college"].stringValue
                    let email = info["email"].stringValue
                    let grade = info["grade"].stringValue
                    let username = info["username"].stringValue
                    let major = info["major"].stringValue
                    let sex = info["sex"].intValue
                    let phone = info["phone"].stringValue
                    let birthday = info["birthday"].stringValue
                    let createTime = info["createTime"].stringValue
                    
                    // MARK: - 写入User Model
                    self.user = BWUser(id: id, username: username, password: password, nickname: nickname, college: college, major: major, grade: grade, birthday: birthday, phone: phone, email: email, realName: realName, sex: sex, createTime: createTime)
                    
                    // MARK: - 将User对象序列化为NSData存进NSUserDefaults
                    let userdata:Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                    UserDefaults.standard.set(userdata, forKey: "BWUser\(userId!)")
                    
                    let userInfo = RCUserInfo()
                    userInfo.userId = userId!
                    userInfo.portraitUri = BWApiurl.getUerImageUrl(userId!)
                    userInfo.name = self.user?.nickname
                    return completion(userInfo)
                default:
                    SVProgressHUD.showError(withStatus: message)
                }
            }
        }
    }
}

