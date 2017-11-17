//
//  BWUser.swift
//  BestWay
//
//  Created by 万志强 on 16/12/8.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import Foundation

// MARK: - User Model
class BWUser: NSObject {
    
    // MARK: - User ID
    var id:Int
    
    // MARK: - 用户名
    var username: String
    
    // MARK: - 教务密码
    var password: String
    
    // MARK: - 昵称
    var nickname: String
    
    // MARK: - 学院名称
    var college: String
    
    // MARK: - 专业
    var major: String
    
    // MARK: - 年级
    var grade: String
    
    // MARK: - 生日
    var birthday: String
    
    // MARK: - 电话
    var phone: String
    
    // MARK: - Email
    var email: String
    
    // MARK: - 真实姓名
    var realName: String
    
    // MARK: - 性别
    var sex: Int
    
    // MARK: - 创建时间
    var createTime: String
    
    // MARK: - 构造方法
    init(id: Int,username: String, password: String, nickname: String, college: String, major: String, grade: String, birthday: String, phone: String, email: String, realName: String, sex: Int, createTime: String) {
        self.id = id
        self.username = username
        self.password = password
        self.nickname = nickname
        self.college = college
        self.major = major
        self.grade = grade
        self.birthday = birthday
        self.phone = phone
        self.email = email
        self.realName = realName
        self.sex = sex
        self.createTime = createTime
    }
    
    // MARK: - 把每个参数编码成NSDefault能储存的格式
    func encodeWithCoder(_ aCoder:NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(college, forKey: "college")
        aCoder.encode(major, forKey: "major")
        aCoder.encode(grade, forKey: "grade")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(realName, forKey: "realName")
        aCoder.encode(sex, forKey: "sex")
        aCoder.encode(createTime, forKey: "createTime")
        
    }
    
    // MARK: - 把NSDefault里的参数解码
    func initWithCoder(_ aDecoder:NSCoder) -> AnyObject {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.username = aDecoder.decodeObject(forKey: "username") as! String
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        self.college = aDecoder.decodeObject(forKey: "college") as! String
        self.major = aDecoder.decodeObject(forKey: "major") as! String
        self.grade = aDecoder.decodeObject(forKey: "grade") as! String
        self.birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        self.phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.realName = aDecoder.decodeObject(forKey: "realName") as! String
        self.sex = aDecoder.decodeInteger(forKey: "sex")
        self.createTime = aDecoder.decodeObject(forKey: "createTime") as! String
        
        return self
    }
}
