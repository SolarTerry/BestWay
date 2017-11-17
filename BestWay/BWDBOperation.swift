//
//  BWDBOperation.swift
//  BestWay
//
//  Created by solar on 17/7/23.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import Foundation
import UIKit
import FMDB
// TODO: - 数据库操作类
class BWDBOperation: NSObject {
    // MARK: - 课程名称
    var courseName: String!
    // MARK: - 任课教师
    var teacher: String!
    // MARK: - 上课教室
    var classroom: String!
    // MARK: - 起始周
    var start: Int!
    // MARK: - 结束周
    var end: Int!
    // MARK: - 上课日期
    var day: Int!
    // MARK: - 课程总周数
    var weeks: Int!
    
    init(dict: [String: AnyObject]) {
        super.init()
        // model类需要实现setValuesForKeys方法
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        // 插入一节课
        func insertCourse() {
            let sql = "INSERT INTO 'BW_COURSE' ('courseName', 'teacher', 'classroom', 'start', 'end', 'day', 'week') values ('\(courseName!)', '\(teacher!)', '\(classroom!)', '\(start!)', '\(end!)', '\(day!)', '\(weeks!)');"
            BWDBManager.shareInstance.dbQueue?.inDatabase({ (db) -> Void in
                try! db?.executeUpdate(sql, values: [courseName!, teacher!, classroom!, start!, end!, day!, weeks!])
            })
        }
        
        // 删除所有课
        func deleteAllCourse() {
            let sql = "DELETE FROM 'BW_COURSE';"
            BWDBManager.shareInstance.dbQueue?.inDatabase({ (db) -> Void in
                try! db?.executeUpdate(sql, values: [])
            })
        }
        
        // 读取所有课
        func getAllCourse() -> [[String: AnyObject]]{
            let sql = "SELECT * FROM 'BW_COURSE';"
            var resultArray = [[String: AnyObject]] = []
            BWDBManager.shareInstance.dbQueue?.inDatabase({ (db) -> Void in
                if let result = try! db.executeQuery(sql, values: []) {
                    while result.next() {
                        let resultCourseName = result.stringForColum("courseName")
                        let resultTeacher = result.stringForColum("teacher")
                        let resultClassroom = result.stringForColum("classroom")
                        let resultStart = result.stringForColum("start").intValue
                        let resultEnd = result.stringForColum("end").intValue
                        let resultDay = result.stringForColum("day").intValue
                        let resultWeek = result.stringForColum("weeks").intValue
                        let dict = ["courseName": resultCourseName, "teacher": resultTeacher, "classroom": resultClassroom, "start": resultStart, "end": resultEnd, "day": resultDay, "weeks": resultWeek]
                        resultArray.append(dict)
                    }
                }
            })
            return resultArray
        }
    }
    
    
}
