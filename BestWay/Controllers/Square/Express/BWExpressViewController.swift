//
//  BWExpressViewController.swift
//  BestWay
//
//  Created by solar on 16/12/12.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
// 所有快递点展示控制器
class BWExpressViewController: UIViewController,UINavigationControllerDelegate{

    // MARK: - 高德地图view
    var mapView = MAMapView()
    
    // MARK: - 主storyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - 快递点id
    var expressIds = [Int]()
    
    // MARK: - 快递点名称数组
    var expressNames = [String]()
    
    // MARK: - 快递点坐标数组
    var expressLocations = [CLLocation]()
    
    // MARK: - 快递点电话数组
    var expressPhones = [String]()
    
    // MARK: - 快递点地址数组
    var expressAddresses = [String]()
    
    // MARK: - 快递点开放时间
    var expressOpenTimes = [String]()
    
    // MARK: - 快递点关闭时间
    var expressCloseTimes = [String]()
    
    // MARK: - 快递点图标url
    var expressLogoURLs = [URL]()
    
    // MARK: - 快递点图标
    var expressLogos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 初始化地图view
        initMapView()
        // MARK: - 初始化快递view
        initExpressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 初始化地图view
    func initMapView(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "快递中心"
        
        // MARK: -地图主view
        let mainView = UIView(frame: CGRect(x:0, y:60, width:self.view.frame.width, height:self.view.frame.height))
        mapView.delegate = self
        mapView = MAMapView(frame: mainView.bounds)
        mapView.zoomLevel = 15
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.none
        mapView.allowsBackgroundLocationUpdates = true
        mapView.pausesLocationUpdatesAutomatically = true
        mapView.distanceFilter = 10.0
        mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mapView.setCenter(CLLocationCoordinate2D.init(latitude: 22.347146, longitude: 113.533344), animated: true)
        
        mainView.addSubview(mapView)
        self.view.addSubview(mainView)
    }
    
    // MARK: - 初始化快递点view
    func initExpressView(){
        mapView.delegate = self
        SVProgressHUD.show(withStatus: "正在加载...")
        DispatchQueue.global().async {
            let requestUtil = BWRequestUtil.shareInstance
            requestUtil.sendRequestResponseJSON(BWApiurl.GET_EXPRESS_INFO, method: .post, parameters: [:]){
                response in
                var responseData = JSON(data: response.data!)

                // 获取json失败
                if(responseData == JSON.null){
                    SVProgressHUD.showError(withStatus: "服务器异常！")
                    return
                }

                var datas = responseData["data"]
                DispatchQueue.main.async{
                    for i in 0..<(datas.count){
                        // 获取快递id
                        let expressId = datas[i]["id"].intValue
                        self.expressIds.append(expressId)
                        
                        // 获取快递名称
                        let expressName = datas[i]["name"].stringValue
                        self.expressNames.append(expressName)
                        
                        // 获取快递地址
                        let expressAddress = datas[i]["address"].stringValue
                        self.expressAddresses.append(expressAddress)
                        
                        // 获取快递电话
                        let expressPhone = datas[i]["phone"].stringValue
                        self.expressPhones.append(expressPhone)
                        
                        // 获取快递坐标
                        let expressLongitude = datas[i]["longitude"].doubleValue
                        let expressLatitude = datas[i]["latitude"].doubleValue
                        let expressLocation = CLLocation.init(latitude: expressLatitude, longitude: expressLongitude)
                        self.expressLocations.append(expressLocation)
                        
                        // 获取快递图标url
                        let expressLogoURLString = datas[i]["logoUrl"].stringValue
                        let expressLogoURL = NSURL(string: expressLogoURLString)
                        self.expressLogoURLs.append(expressLogoURL! as URL)
                        
                        // 获取快递图标
                        let expressLogoData = NSData(contentsOf: expressLogoURL as! URL)
                        let expressLogo = UIImage(data: expressLogoData as! Data)
                        self.expressLogos.append(expressLogo!)
                        
                        // 获取快递开放时间
                        let expressOpenTime = datas[i]["openTime"].stringValue
                        self.expressOpenTimes.append(expressOpenTime)
                        
                        // 获取快递关闭时间
                        let expressCloseTime = datas[i]["closeTime"].stringValue
                        self.expressCloseTimes.append(expressCloseTime)
                        
                        // 戳点
                        let expressPoint = MAPointAnnotation()
                        expressPoint.coordinate = self.expressLocations[i].coordinate
                        expressPoint.title = self.expressNames[i]
                        expressPoint.subtitle = self.expressAddresses[i]
                        
                        self.mapView.addAnnotation(expressPoint)
                    }
                    SVProgressHUD.showSuccess(withStatus: "加载完成！")
                }
            }
        }
    }
}

// MARK: - 实现BWExpressViewController的MAMapViewDelegate代理方法
extension BWExpressViewController: MAMapViewDelegate{
    // MARK: - 标注代理方法
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self){
            let annotationIdentifier = "locationIentifier"
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MAPinAnnotationView
            if poiAnnotationView == nil{
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            // 修改快递图标尺寸
            let expressLogoSize = CGSize(width: 40, height: 40)
            let expressLogo = expressLogos.last?.setImageSize(expressLogoSize)
            
            poiAnnotationView!.image = expressLogo
            poiAnnotationView!.animatesDrop = false
            poiAnnotationView!.canShowCallout = true
            
            // 设置去代领按钮属性
            let btn:UIButton = UIButton(type: .system)
            btn.frame = CGRect(x: 10, y: 150, width: 80, height: 30)
            btn.setTitle("去代领👉", for: UIControlState())
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.setBackgroundImage(UIImage.init().imageWithColor(color: UIColor.colorFromRGB(0x9fc5e8), size: btn.frame.size), for: UIControlState.normal)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 5.0
            poiAnnotationView?.rightCalloutAccessoryView = btn
            
            return poiAnnotationView
        }
        return nil
    }
    
    // MARK: - 气泡弹窗点击事件代理方法
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control.isKind(of: UIControl.self){
            let expressInfoTableViewController = BWExpressInfoTableViewController(nibName: "BWExpressInfoTableViewController", bundle: nil)
            
            // 获取快递信息在数组里的下标
            var count = 0
            for i in 0..<expressNames.count {
                if expressNames[i] == view.annotation.title {
                    count = i
                }
            }
            
            // 修改快递图标尺寸
            let expressLogoSize = CGSize(width: 100, height: 100)
            let expressLogo = expressLogos[count].setImageSize(expressLogoSize)
            
            // 页面传參
            expressInfoTableViewController.expressName = view.annotation.title
            expressInfoTableViewController.navigationItem.title = view.annotation.title
            expressInfoTableViewController.expressLogo = expressLogo
            expressInfoTableViewController.expressId = expressIds[count]
            expressInfoTableViewController.expressPhone = expressPhones[count]
            expressInfoTableViewController.expressOpenTime = expressOpenTimes[count]
            expressInfoTableViewController.expressCloseTime = expressCloseTimes[count]
            expressInfoTableViewController.expressAddress = expressAddresses[count]
            // 页面跳转
            self.navigationController!.pushViewController(expressInfoTableViewController, animated: true)
        }
    }
}
