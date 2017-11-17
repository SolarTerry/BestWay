//
//  BWCourse.swift
//  BestWay
//
//  Created by solar on 17/7/23.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import Foundation
// 课程model
class BWCourse: NSObject, NSCoding {
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
    
    override init() {
        
    }
    
    // MARK: - 编码
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.courseName, forKey: "courseName")
        aCoder.encode(self.teacher, forKey: "teacher")
        aCoder.encode(self.classroom, forKey: "classroom")
        aCoder.encode(self.start, forKey: "start")
        aCoder.encode(self.end, forKey: "end")
        aCoder.encode(self.day, forKey: "day")
        aCoder.encode(self.weeks, forKey: "weeks")
    }
    
    // MARK: - 初始化时解码
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.courseName = aDecoder.decodeObject(forKey: "courseName") as! String
        self.teacher = aDecoder.decodeObject(forKey: "teacher") as! String
        self.classroom = aDecoder.decodeObject(forKey: "classroom") as! String
        self.start = aDecoder.decodeObject(forKey: "start") as! Int
        self.end = aDecoder.decodeObject(forKey: "end") as! Int
        self.day = aDecoder.decodeObject(forKey: "day") as! Int
        self.weeks = aDecoder.decodeObject(forKey: "weeks") as! Int
    }
}
