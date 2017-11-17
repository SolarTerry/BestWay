//
//  MainViewController.swift
//  BestWay
//
//  Created by 万志强 on 16/11/6.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SocketRocket
// 主页控制器
class BWMainViewController: UIViewController, AMapSearchDelegate, UISearchBarDelegate {
    // MARK: - 首页地图主界面
    var mainView = UIView()
    
    // MARK: - 搜索框view
    var barView = UIView()
    
    // MARK: - 地图view
    var mapView = MAMapView()
    
    // MARK: - 首页搜索框
    var searchBar = UISearchBar()
    
    // MARK: - 定位按钮
    var locationBtn = UIButton()

    // MARK: - 定位按钮tag
    let LOCATION_BTN_TAG = 1
    
    // MARK: - 电瓶车宽度
    var carwidth = 20.0
    
    // MARK: - 电瓶车长度
    var carheight = 10.0
    
    // MARK: - 地图缩放大小
    var scale = 15.1
    
    // MARK: - 地图缩放前后大小差值
    var difference = 0.0
    
    // MARK: - POI搜索对象
    var search:AMapSearchAPI?
    
    // MARK: - 搜索结果数组
    var searchResult:[AMapPOI] = []
    
    // MARK: - 搜索框页面传參字符串
    var itemString = ""
    
    // MARK: - 当前用户
    var user:BWUser?
    
    // MARK: - 网络访问工具类
    let requestUtil = BWRequestUtil.shareInstance
    
    // MARK: - Websocket工具类
    var socketRocket:SRWebSocket?
    
    // MARK: - 车辆标注数组
    var carAnnotations:[Int:MAPointAnnotation] = [:]
    
    // MARK: - 海三电瓶车站点
    var haisanStationAnnotation: BWStationAnnotation!
    
    // MARK: - 励耘电瓶车站点
    var liyunStationAnnotation: BWStationAnnotation!
    
    // MARK: - 学三电瓶车站点
    var xuesanStationAnnotation: BWStationAnnotation!
    
    var cacheRequest: URLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化界面
        initView()
        
        // 设置用户信息
        setUpUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 隐藏navigationbar
        self.navigationController?.isNavigationBarHidden = true
        
        // 连接websocket服务器
        self.connectWebSocket()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 断开与Websocket连接
        self.resetWebsocket()
        
        // 清空所有车辆标注
        for carAnnotation in self.carAnnotations.values {
            self.mapView.removeAnnotation(carAnnotation)
        }
        
        // 清空所有车辆标注
        self.carAnnotations.removeAll()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 初始化窗体
    func initView(){
        mainView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height))
    
        // MARK: -设置搜索框view相关属性
        barView = UIView(frame: CGRect(x:10, y:30, width:self.view.frame.width-20, height:40))
        barView.layer.masksToBounds = true
        barView.layer.cornerRadius = 10
        barView.layer.backgroundColor = UIColor(red: 49/255, green: 151/255, blue: 230/255, alpha: 0.9).cgColor
        
        // MARK: - 设置定位按钮相关属性
        locationBtn = UIButton(frame: CGRect(x:self.view.frame.width-60,y:self.view.frame.height-100, width:40,height:40))
        locationBtn.setImage(UIImage(named:"location"), for: UIControlState.normal)
        locationBtn.tag = LOCATION_BTN_TAG
        locationBtn.addTarget(self, action: #selector(BWMainViewController.buttonClicked), for: .touchUpInside)
        
        // MARK: - 设置地图view相关属性
        mapView = MAMapView(frame:mainView.bounds)
        mapView.delegate = self
        mapView.zoomLevel = self.scale
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.none
        mapView.pausesLocationUpdatesAutomatically = true
        mapView.allowsBackgroundLocationUpdates = true
        mapView.distanceFilter = 10.0
        mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mapView.setCenter(CLLocationCoordinate2D.init(latitude: 22.348092, longitude: 113.53586), animated: true)
        mapView.showsScale = false
        mapView.showsCompass = false
        mapView.delegate = self
        mainView.addSubview(mapView)
        
        // MARK: - 设置搜索框的相关属性
        searchBar = UISearchBar(frame: barView.bounds)
        searchBar.placeholder = "请输入校园内地址"
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        // 通过取出searchbar里的textfield来改变searchbar的placeholder的字体颜色
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar?.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        searchBar.delegate = self
        
        // MARK: - 设置海三电瓶车站点相关属性
        haisanStationAnnotation = BWStationAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.346717, longitude: 113.52913))
        haisanStationAnnotation.title = "海三站"
        haisanStationAnnotation.stationId = "1"
        
        // MARK: - 设置励耘电瓶车站点相关属性
        liyunStationAnnotation = BWStationAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.351547, longitude: 113.542989))
        liyunStationAnnotation.title = "励耘站"
        liyunStationAnnotation.stationId = "3"
        
        // MARK: - 设置学三电瓶车站点相关属性
        xuesanStationAnnotation = BWStationAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.348917, longitude: 113.532987))
        xuesanStationAnnotation.title = "学三站"
        xuesanStationAnnotation.stationId = "2"
        
        mapView.addAnnotation(haisanStationAnnotation)
        mapView.addAnnotation(liyunStationAnnotation)
        mapView.addAnnotation(xuesanStationAnnotation)
        
        barView.addSubview(searchBar)
    
        self.view.addSubview(mainView)
        self.view.addSubview(locationBtn)
        self.view.addSubview(barView)
        self.view.bringSubview(toFront: barView)
        
    }
    
    
    // MARK: - 搜索框回调方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 页面传參的内容
        itemString = self.searchBar.text!
        self.performSegue(withIdentifier: "showSearchResult", sender: itemString)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResult"{
            // 代码控制跳转
            let controller = segue.destination as! BWSearchResultViewController
            // 页面传參
            controller.itemString = sender as! String
        }
    }
    
    
    // MARK: - 按钮监听事件处理
    func buttonClicked(_ sender: UIButton){
        switch sender.tag {
        // MARK: - 定位按钮事件
        case LOCATION_BTN_TAG:
            mapView.userTrackingMode = MAUserTrackingMode.follow
            mapView.isShowsUserLocation = true
        default:
            return
        }
    }
    
    
    // MARK: - 初始化用户信息
    func setUpUserInfo() {
        let requestUtil = BWRequestUtil.shareInstance
        let userData = UserDefaults.standard.data(forKey: "BWUser")
        
        // 尝试从本地获取用户信息
        if userData != nil {
            user = (NSKeyedUnarchiver.unarchiveObject(with: userData!) as! BWUser)
            
            // 初始化融云
            initRongCloudService((user?.nickname)!)
        } else {
            cacheRequest = requestUtil.sendRequestResponseJSONURLRequest(BWApiurl.GET_USER_INFO, method: .post, parameters: [:]) { response in
                SVProgressHUD.show(withStatus: "数据加载中...")
                var data = JSON(data: response.data!)
                // 返回数据为空
                if data == JSON.null {
                    SVProgressHUD.showError(withStatus: "服务器异常！")
                    return
                }
                var info = data["data"]
                
                // 返回的Message信息
                let message = data["message"].stringValue
                
                // 返回的Code
                let code = data["code"].intValue
                
                // 判断code类型
                switch code {
                case 0:
                    // 解析出JSON中信息
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
                    
                    // 写入User Model
                    self.user = BWUser(id: id, username: username, password: password, nickname: nickname, college: college, major: major, grade: grade, birthday: birthday, phone: phone, email: email, realName: realName, sex: sex, createTime: createTime)
                    
                    // 将User对象序列化为NSData存进NSUserDefaults
                    let userdata:Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                    UserDefaults.standard.set(userdata, forKey: "BWUser")
                    
                    // 初始化融云
                    self.initRongCloudService((self.user?.nickname)!)
                    
                default:
                    
                    // 清除所有本地数据
                    let dict = UserDefaults.standard.dictionaryRepresentation()
                    for key in dict {
                        UserDefaults.standard.removeObject(forKey: key.key)
                    }
                    
                    let alertController = UIAlertController.alertControllerWithActionNoCancel("警告", msg: "当前登录已过期，请重新登录", actionTitle: "好的", action: { (UIAlertAction) in
                        
                        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
                        self.present(loginVc!, animated: true, completion: nil)
                        
                    })
                    self.present(alertController, animated: true, completion: nil)
                    SVProgressHUD.showError(withStatus: message)
                }
            }
        }
    }
    
    // MARK: - Websockt服务
    func connectWebSocket() {
//        self.socketRocket = SRWebSocket(url: URL(string: BWApiurl.CAR_INFO_WS))
        cacheRequest?.url = URL(string: BWApiurl.CAR_INFO_WS)
        let url = NSURL(string: "https://lbs.bnuz.edu.cn")
        let cookieJar = HTTPCookieStorage.shared.cookies(for: url! as URL)
        self.socketRocket = SRWebSocket(url: URL(string: BWApiurl.CAR_INFO_WS))
        self.socketRocket?.requestCookies = cookieJar
//        self.socketRocket = SRWebSocket(urlRequest: cacheRequest)
        self.socketRocket?.delegate = self
        self.socketRocket?.open()
    }
    
    // MARK: - Websockt服务
    func resetWebsocket() {
        // 页面不可见时关闭Websocket连接
        self.socketRocket?.delegate = nil
        self.socketRocket?.close()
        self.socketRocket = nil
    }
    
    // MARK: - 初始化融云服务
    func initRongCloudService(_ nickname:String) {
        
        // 从本地获取融云Token
        var rcToken = UserDefaults.standard.string(forKey: "rcToken")
        
        // 如果本地存在Token则优先使用，如果过期，则从网络重新获取
        if rcToken != nil {
            print("本地获取Token")
            let pushToken = UserDefaults.standard.string(forKey: "pushToken")
            RCIMClient.shared().setDeviceToken(pushToken)
            RCIM.shared().connect(withToken: rcToken, success: { (userId) -> Void in
                print("登陆成功。当前登录的用户ID：\(userId)")

                // 设置当前用户信息
                let currentUserInfo = RCUserInfo(userId: userId!, name: nickname, portrait: BWApiurl.getUerImageUrl(userId!))
                RCIM.shared().currentUserInfo = currentUserInfo
                                    
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
             self.requestUtil.sendRequestResponseJSON(BWApiurl.GET_RONGCLOUD_TOKEN, method: .post, parameters: ["nickname" : nickname],  completionHandler: { (response) in
                    var data = JSON(data: response.data!)
                    // 返回数据为空
                    if data == JSON.null {
                        SVProgressHUD.showError(withStatus: "服务器异常！")
                        return
                    }
                    
                    // 返回的Message信息
                    let message = data["message"].stringValue
                    
                    // 返回的Code
                    let code = data["code"].intValue
                    
                    // 包含Token的数据
                    var info = data["data"]
                    
                    if (code == 0) {
                        rcToken = info["token"].string
                        RCIM.shared().connect(withToken: rcToken, success: { (userId) -> Void in
                            print("登陆成功。当前登录的用户ID：\(userId)")
                                                
                            // 设置当前用户信息
                            let currentUserInfo = RCUserInfo(userId: userId!, name: nickname, portrait: BWApiurl.getUerImageUrl(userId!))
                            RCIM.shared().currentUserInfo = currentUserInfo
                                                
                            // 将融云Token存在本地
                            UserDefaults.standard.set(rcToken, forKey: "rcToken")
                                                
                        }, error: { (status) -> Void in
                            print("登陆的错误码为:\(status.rawValue)")
                            let alertViewController = UIAlertController.alertControllerWithTitle("错误", msg: "登录聊天服务器失败，请检查网络连接后重试")
                            self.present(alertViewController, animated: true, completion: nil)
                        }, tokenIncorrect: {
                            let alertViewController = UIAlertController.alertControllerWithTitle("错误", msg: "登录聊天服务器失败，请检查网络连接后重试")
                            self.present(alertViewController, animated: true, completion: nil)
                        })
                        SVProgressHUD.showSuccess(withStatus: "获取成功")
                    } else {
                        SVProgressHUD.showError(withStatus: message)
                    }
                })
            })
        }
        
        if rcToken == nil {
            requestUtil.sendRequestResponseJSON(BWApiurl.GET_RONGCLOUD_TOKEN, method: .post, parameters: ["nickname" : nickname],  completionHandler: { (response) in
                var data = JSON(data: response.data!)
                // 返回数据为空
                if data == JSON.null {
                    SVProgressHUD.showError(withStatus: "服务器异常！")
                    return
                }
                
                // 返回的Message信息
                let message = data["message"].stringValue
                
                // 返回的Code
                let code = data["code"].intValue
                
                // 包含Token的数据
                var info = data["data"]
                
                if (code == 0) {
                    rcToken = info["token"].string
                    RCIM.shared().connect(withToken: rcToken, success: { (userId) -> Void in
                        print("登陆成功。当前登录的用户ID：\(userId)")
                                            
                        // 设置当前用户信息
                        let currentUserInfo = RCUserInfo(userId: userId!, name: nickname, portrait: BWApiurl.getUerImageUrl(userId!))
                        RCIM.shared().currentUserInfo = currentUserInfo
                        // 将融云Token存在本地
                        UserDefaults.standard.set(rcToken, forKey: "rcToken")
                    }, error: { (status) -> Void in
                        print("登陆的错误码为:\(status.rawValue)")
                        let alertViewController = UIAlertController.alertControllerWithTitle("错误", msg: "登录聊天服务器失败，请检查网络连接后重试")
                        self.present(alertViewController, animated: true, completion: nil)
                    }, tokenIncorrect: {
                        let alertViewController = UIAlertController.alertControllerWithTitle("错误", msg: "登录聊天服务器失败，请检查网络连接后重试")
                        self.present(alertViewController, animated: true, completion: nil)
                    })
                    SVProgressHUD.showSuccess(withStatus: "获取成功")
                } else {
                    SVProgressHUD.showError(withStatus: message)
                }
            })
        }
    }
}

// MARK: - 实现BWMainViewController的SRWebSocketDelegate代理方法
extension BWMainViewController: SRWebSocketDelegate {
    
    // MARK: - 接收消息的代理方法
    public func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        // 处理JSON字符串
        let data = JSON(parseJSON: message as! String)
        
        // 处理无效数据
        if data == JSON.null {
            return
        }
        
        // 解析出的车辆编码
        let carNo = data["carId"].intValue
        
        var carAnnotation = carAnnotations[carNo]
        carAnnotation?.title = "\(carNo)"
        if carAnnotation != nil {
            
            // 更新车辆标注的位置
            carAnnotation?.coordinate = AMapCoordinateConvert(CLLocationCoordinate2DMake(data["latitude"].doubleValue,data["longitude"].doubleValue), .GPS)
        } else {
            // 如果是新增的车辆数据，则创建一个新的标注
            carAnnotation = MAPointAnnotation()
            carAnnotation?.coordinate = AMapCoordinateConvert(CLLocationCoordinate2DMake(data["latitude"].doubleValue,data["longitude"].doubleValue), .GPS)
            
            self.carAnnotations.updateValue(carAnnotation!, forKey: carNo)
            self.mapView.addAnnotation(carAnnotation)
        }
    }
    
    // MARK: - 断开连接的代理方法
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        // 出错时断开连接
        self.resetWebsocket()
        print(code)
        
        if reason == nil {
            let alert = UIAlertController.alertControllerWithTitle("提示", msg: "连接错误！")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if reason.contains("timeout") {
            let alert = UIAlertController.alertControllerWithAction("提示", msg: "由于长时间未操作，车辆信息服务器连接超时，请重新连接！", actionTitle: "连接", action: { (UIAlertAction) in
                self.connectWebSocket()
            })
            self.present(alert, animated: true, completion: nil)
        } else if reason.contains("stopping"){
            let alert = UIAlertController.alertControllerWithTitle("提示", msg: "车辆信息服务器已关闭，请稍后重试！")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - 连接出错的代理方法
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        let alert = UIAlertController.alertControllerWithAction("提示", msg: "连接车辆数据服务器失败，请重试或联系管理员！", actionTitle: "连接", action: { (UIAlertAction) in
            self.connectWebSocket()
        })
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - 实现BWMainViewController的MAMapViewDelegate代理方法
extension BWMainViewController: MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        for carAnnotation in carAnnotations {
            let poiAnnotationView = MAPinAnnotationView(annotation: carAnnotation.value, reuseIdentifier: "carIdentifier")
            if wasUserAction {
                difference = mapView.zoomLevel - scale
                if difference > 0{
                    print("bigger")
                    let image = UIImage(named: "car")
                    let resizeImage = image?.setImageSize(CGSize(width: 40, height: 40))
                    poiAnnotationView?.image = resizeImage
                }else{
                    let image = UIImage(named: "car")
                    let resizeImage = image?.setImageSize(CGSize(width: 10, height: 10))
                    poiAnnotationView?.image = resizeImage
                    print("smaller")
                }
                scale = mapView.zoomLevel
                print(mapView.center)
            }
        }
    }
    
    // MARK: - 地图标注代理方法重写
    func mapView(_ viewFormapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        userLocation = self.mapView.userLocation.coordinate
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationIdentifier = "carIdentifier"
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MAPinAnnotationView
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            poiAnnotationView!.image = UIImage(named: "car")?.setImageSize(CGSize(width: 20, height: 10))
            poiAnnotationView!.animatesDrop   = false
            poiAnnotationView!.canShowCallout = true
            return poiAnnotationView
        } else if annotation is BWStationAnnotation {
            let annotationIdentifier = "stationIdentifier"
            var stationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? BWStationAnnotationView
            if stationAnnotationView == nil {
                stationAnnotationView = BWStationAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier,mapView: self.mapView)
            }
            let image = UIImage(named: "station")
            let resizedImage = image?.setImageSize(CGSize(width: 20, height: 20))
            stationAnnotationView!.image = resizedImage
            stationAnnotationView?.stationId = (annotation as! BWStationAnnotation).stationId
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            stationAnnotationView!.canShowCallout = false
            stationAnnotationView?.rightCalloutAccessoryView = view
            return stationAnnotationView
        }
        return nil
    }
    
    // MARK: - 点击地图键盘消失
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        self.searchBar.resignFirstResponder()
    }
    
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control.isKind(of: UIControl.self) {
            
        }
    }
    
}
