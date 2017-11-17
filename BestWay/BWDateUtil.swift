//
//  BWDataUtil.swift
//  BestWay
//
//  Created by 万志强 on 16/12/3.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import Foundation

// 日期类公共工具类
class BWDateUtil {
    
    // MARK: - 将TimeStamp转换成日期String
    static func timeStampToString(_ timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日"
        let date = Date(timeIntervalSince1970: timeSta/1000)
        return dfmatter.string(from: date)
    }
    
    // MARK: - 将TimeStamp转换成格式为yyyy年MM月dd日HH:mm的日期String
    static func timeStampToYMDHMString(_ timeStamp: String) -> String {
        let timeString = NSString(string:timeStamp)
        let timeSta = timeString.doubleValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日HH:mm"
        let date = NSDate(timeIntervalSince1970: timeSta / 1000)
        return dateFormatter.string(from: date as Date)
    }

    // MARK: - 获取当前时间字符串
    static func getTimeString() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmm"
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }
}
