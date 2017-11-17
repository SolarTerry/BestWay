//
//  Apiurl.swift
//  BestWay
//
//  Created by 万志强 on 16/11/4.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import Foundation

//业务服务器地址
//let ServerUrl = "http://127.0.0.1:8080"
//let ServerUrl = "http://119.29.26.40/"
//let WebSocketUrl = "http://127.0.0.1:8080"
//let WebSocketUrl = "http://119.29.26.40/"
let ServerUrl = "https://lbs.bnuz.edu.cn/api"
let WebSocketUrl = "https://lbs.bnuz.edu.cn"
//let ServerUrl = "http://192.168.95.2:8080/api"
//let WebSocketUrl = "http://192.168.2.1:8080"


struct BWApiurl {
    
    // MARK: - 车辆信息websockt
    static let CAR_INFO_WS = WebSocketUrl + "/ws/car"
    
    // MARK: - 七牛云
    static let QINIU_CLOUD = "https://cdnssl.terrylovesolar.com"
    
    // MARK: - 用户登录
    static let LOGIN_CHECK = ServerUrl + "/user/login"
    
    // MARK: - 获取用户信息
    static let GET_USER_INFO = ServerUrl + "/user/info/get"
    
    // MARK: - 获取好友信息
    static let GET_FRIEND_INFO = ServerUrl + "/relation/friends/info"
    
    // MARK: - 获取融云Token
    static let GET_RONGCLOUD_TOKEN = ServerUrl + "/rongcloud/token/get"
    
    // MARK: - 删除七牛空间指定图片
    static let DELETE_QINIU_FILE = ServerUrl + "/qiniu/delete_file"
    
    // MARK: - 获取七牛上传Token
    static let GET_QINIU_TOKEN = ServerUrl + "/qiniu/get_token"
    
    // MARK: - 构造用户头像地址
    static func getUerImageUrl(_ username:String) -> String {
        return "\(QINIU_CLOUD)/userlogo/\(username).png?v=\(BWDateUtil.getTimeString())"
    }
    
    // MARK: - 获取轮播图片
    static let GET_SCROLL_FILE = ServerUrl + "/sys/banner/all"
    
    // MARK: - 获取全部快递点信息
    static let GET_EXPRESS_INFO = ServerUrl + "/express/site/all"
    
    // MARK: - 获取单个快递点信息
    static let GET_EXPRESS_SITE_INFO = ServerUrl + "/express/site/info"
    
    // MARK: - 用户发起新的订单
    static let CREAT_NEW_ORDER = ServerUrl + "/express/order/add"
    
    // MARK: - 获取对应用户名下的所有订单
    static let GET_ALL_EXPRESS_ORDER = ServerUrl + "/express/order/all"
    
    // MARK: - 取消自己的某一个订单
    static let CANCEL_AN_EXPRESS_ORDER = ServerUrl + "/express/order/cancel"
    
    // MARK: - 发送一个排队等候请求，每五分钟只能成功请求一次
    static let CAR_WAITING_REQUEST = ServerUrl + "/car/waiting/request/add"
    
    // MARK: - 获取排队人数
    static let GET_CAR_WAITING_PEOPLE = ServerUrl + "/car/waiting/request/get"
    
    // MARK: - 获取对应快递点所有有效订单
    static let GET_SITE_ORDER_ALL = ServerUrl + "/express/site/order/all"
}
