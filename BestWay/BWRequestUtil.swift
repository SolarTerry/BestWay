//
//  BWRequestUtil.swift
//  BestWay
//
//  Created by 万志强 on 16/12/3.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import Alamofire
import Foundation

// 网络请求类公共工具类
class BWRequestUtil {
    
     // MARK: - 单例
    static let shareInstance = BWRequestUtil()
    
    func sendRequestResponseData(_ url:String, method:HTTPMethod, parameters:[String: Any], completionHandler:@escaping ((DataResponse<Data>) -> Void)) {
        Alamofire.request(url, method: method, parameters: parameters).responseData(completionHandler: completionHandler)
    }
    
    func sendRequestResponseJSON(_ url:String, method:HTTPMethod, parameters:[String: Any], completionHandler:@escaping ((DataResponse<Any>) -> Void)) {
        Alamofire.request(url, method: method, parameters: parameters).responseJSON(completionHandler: completionHandler)
        
    }
    
    func sendRequestResponseJSONURLRequest(_ url:String, method:HTTPMethod, parameters:[String: Any], completionHandler:@escaping ((DataResponse<Any>) -> Void)) -> URLRequest {
        return Alamofire.request(url, method: method, parameters: parameters).responseJSON(completionHandler: completionHandler).request!
        
    }
}
