//
//  BWStationAnnotationView.swift
//  BestWay
//
//  Created by 万志强 on 17/3/2.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire
import SwiftyJSON
// 电瓶车站点戳点
class BWStationAnnotationView: MAAnnotationView {
    
    // MARK: - 标注图片
    var imageView:UIImageView?
    // MARK: - 气泡弹窗内容与上边框的间距
    let kHoriMargin = CGFloat(5)
    // MARK: - 气泡弹窗内容与边框两边的间距
    let kVertMargin = CGFloat(5)
    // MARK: - 标题宽度
    let kTitleWidth = CGFloat(50)
    // MARK: - 标题高度
    let kTitleHeight = CGFloat(50)
    // MARK: - 气泡弹窗宽度
    let kCalloutWidth = CGFloat(200)
    // MARK: - 气泡弹窗高度
    let kCalloutHeight = CGFloat(160)
    // MARK: - 气泡弹窗小箭头高度
    let kArrorHeight = CGFloat(10)
    // MARK: - 气泡弹窗
    var calloutView = UIView()
    // MARK: - 站名label
    var titleLabel = UILabel()
    // MARK: - 排队人数label
    var peopleLabel = UILabel()
    // MARK: - 预计等待时间label
    var timeLabel = UILabel()
    // MARK: - 排队按钮
    var button = UIButton()
    // MARK: - 车站名
    var title:String!
    // MARK: - 排队人数
    var people:Int!
    // MARK: - 预计排队时间
    var time = Int(100)
    // MARK: - 车站id
    var stationId:String!
    // MARK: - 判断是否在车站附近的标识
    var flag = true
    // MARK: - 车站中心点
    var stationCenter: CLLocationCoordinate2D!
    // MARK: - 地图view
    var mapView:MAMapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(annotation:MAAnnotation,reuseIdentifier:String,mapView:MAMapView) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        self.imageView = UIImageView(frame: self.bounds)
        // 站名
        title = annotation.title
        // 车站id
        stationId = (annotation as! BWStationAnnotation).stationId
        // 车站坐标赋值
        stationCenter = annotation.coordinate
        self.addSubview(self.imageView!)
        self.mapView = mapView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            // MARK: - 设置弹窗相关属性
            self.calloutView = BWStationCalloutView(frame: CGRect(x: 0, y: 0, width: self.kCalloutWidth, height: self.kCalloutHeight))
            self.calloutView.center = CGPoint(x: self.bounds.width / 2 + self.calloutOffset.x, y: -self.bounds.height * 4)
            self.calloutView.backgroundColor = UIColor.clear
            
            // MARK: - 设置站名label相关属性
            titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 30))
            titleLabel.text = title
            titleLabel.textColor = UIColor.colorFromRGB(0xF0FFFF)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            // MARK: - 设置排队人数label相关属性
            peopleLabel = UILabel(frame: CGRect(x: 10, y: 40, width: 180, height: 30))
            peopleLabel.textColor = UIColor.white
            peopleLabel.font = UIFont.systemFont(ofSize: 15.0)
            peopleLabel.text = "排队人数：加载中..."
            getPeople()
            
            // MARK: - 设置预计等待时间label相关属性
            timeLabel = UILabel(frame: CGRect(x: 10, y: 70, width: 180, height: 30))
            timeLabel.text = "预计等待时间：敬请期待"
            timeLabel.textColor = UIColor.white
            timeLabel.font = UIFont.systemFont(ofSize: 15.0)
            
            // MARK: - 设置点击排队按钮相关属性
            button = UIButton(frame: CGRect(x: 20, y: 105, width: 160, height: 35))
            button.setTitle("点击排队", for: UIControlState.normal)
            button.setBackgroundImage(UIImage.init().imageWithColor(color: UIColor.white, size: button.frame.size), for: .normal)
            button.setBackgroundImage(UIImage.init().imageWithColor(color: UIColor.colorFromRGB(0x1E90FF), size: button.frame.size), for: .highlighted)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5.0
            button.setTitleColor(UIColor.colorFromRGB(0x5B5B5B), for: .normal)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.addTarget(self, action: #selector(BWStationAnnotationView.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
            
            self.calloutView.addSubview(titleLabel)
            self.calloutView.addSubview(button)
            self.calloutView.addSubview(peopleLabel)
            self.calloutView.addSubview(timeLabel)
            self.bringSubview(toFront: titleLabel)
            self.addSubview(self.calloutView)
            
        }else {
            self.calloutView.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - 按钮处理方法
    func buttonClicked(sender: UIButton) {
        // 判断是否在车站附近
        flag = MACircleContainsCoordinate(userLocation, stationCenter, 100)
        if flag {
            SVProgressHUD.show(withStatus: "正在排队...")
            // 排队参数
            let parameters = ["requestLocationId": stationId!, "latitude": userLocation.latitude, "longitude": userLocation.longitude] as [String : Any]
            // 向服务端发送排队请求
            let requestUtil = BWRequestUtil.shareInstance
            requestUtil.sendRequestResponseJSON(BWApiurl.CAR_WAITING_REQUEST, method: .post, parameters: parameters){
                (response) in
                let data = JSON(data: response.data!)
                if data == JSON.null {
                    SVProgressHUD.showError(withStatus: "服务器异常！")
                    return
                }
                // 排队结果
                let message = data["message"].stringValue
                // 排队结果状态码
                let code = data["code"].stringValue
                // 判断是否频繁操作
                if code == "50001" {
                    SVProgressHUD.showError(withStatus: message)
                    return
                }
                SVProgressHUD.showSuccess(withStatus: message)
                self.getPeople()
            }
        }else {
            SVProgressHUD.showError(withStatus: "请在车站附近使用该功能！")
        }
    }
    
    // MARK: - 获取排队人数
    func getPeople() {
        // 请求参数
        let parameters = ["duration":5,"locationId":self.stationId!] as [String : Any]
        // 向服务器发送获取排队人数请求
        let requestUtil = BWRequestUtil.shareInstance
        requestUtil.sendRequestResponseJSON(BWApiurl.GET_CAR_WAITING_PEOPLE, method: .post, parameters: parameters){
            response in
            var responseData = JSON(data: response.data!)
            if responseData == JSON.null {
                SVProgressHUD.showError(withStatus: "服务器异常！")
                return
            }
            let data = responseData["data"]
            let requestCount = data["requestCount"].intValue
            self.people = requestCount
            self.peopleLabel.text = "排队人数：\(self.people!)"
        }
    }
}
