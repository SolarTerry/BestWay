//
//  BWDatabaseOperations.swift
//  BestWay
//
//  Created by solar on 17/8/1.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import Foundation

// MARK: - 数据库操作，sqlite版
class BWDatabaseOperations: NSObject {
    // 不透明指针，对应C语言里面的void *，这里指sqlite3指针
    private var db: OpaquePointer? = nil
    
    static let shared = BWDatabaseOperations()
    
    // 初始化方法打开数据库
    internal required override init() {
        
        // 声明一个Documents下的路径，将Bundle.main路径下的数据库文件复制到Documents下
        let dbPath = NSHomeDirectory() + "/Documents/BestWay.db"
        print(dbPath)
        // 判断数据库文件是否存在
        if !FileManager.default.fileExists(atPath: dbPath) {
            // 获取安装包内数据库路径
            let bundleDBPath = Bundle.main.path(forResource: "BestWay", ofType: "db")!
            // 将安装包内数据库拷贝到Documents目录下
            do {
                try FileManager.default.copyItem(atPath: bundleDBPath, toPath: dbPath)
            } catch let error as NSError{
                print(error)
            }
        }
        // 打开数据库
        let error = sqlite3_open(dbPath, &db)
        
        // 数据库打开失败处理
        if error != SQLITE_OK {
            print("失败打开数据库")
            sqlite3_close(db)
        }else {
            print("成功打开数据库")
        }
        
        print("建表ing")
        // sql语句 （CREATE TABLE IF NOT EXISTS）
        let sql = "CREATE TABLE IF NOT EXISTS BWCourseTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, courseName TEXT NOT NULL, teacher TEXT NOT NULL, classroom TEXT NOT NULL, start INTEGER NOT NULL, end INTEGER NOT NULL, day INTEGER NOT NULL, weeks INTEGER NOT NULL)"
        // 执行sql语句
        let executeResult = sqlite3_exec(db, sql, nil, nil, nil)
        // 判断是否执行成功
        if executeResult != SQLITE_OK {
            print("建表失败\(executeResult)")
        } else {
            print("建表成功")
        }  
    }
    

    
    deinit {
        self.colseDB()
    }
    
    // 关闭数据库
    func colseDB() {
        sqlite3_close(db)
    }
    
    // 代码创建表
//    func createTable() -> Bool {
//        print("建表ing")
//        // sql语句 （CREATE TABLE IF NOT EXISTS）
//        let sql = "CREATE TABLE IF NOT EXISTS BWCourseTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, courseName TEXT NOT NULL, teacher TEXT NOT NULL, classroom TEXT NOT NULL, start INTEGER NOT NULL, end INTEGER NOT NULL, day INTEGER NOT NULL, weeks INTEGER NOT NULL)"
//        // 执行sql语句
//        let executeResult = sqlite3_exec(db, sql.cString(using: String.Encoding.utf8), nil, nil, nil)
//        // 判断是否执行成功
//        if executeResult != SQLITE_OK {
//            print("建表失败\(executeResult)")
//            return false
//        }
//        print("建表成功")
//        return true
//    }
    
    // 插入一条信息
    func addCourse(course: BWCourse) -> Bool {
        print("插入信息ing")
        // sql语句
        let sql = "INSERT INTO BWCourseTable (courseName, teacher, classroom, start, end, day, weeks) VALUES (?,?,?,?,?,?,?);"

        // sqlite3_stmt 指针
        var stmt: OpaquePointer? = nil
        // 编译sql
        let prepareResult = sqlite3_prepare_v2(db, sql, -1, &stmt, nil)
        // 判断如果失败，获取失败信息
        if prepareResult != SQLITE_OK {
            sqlite3_finalize(stmt)
            if let error = sqlite3_errmsg(db) {
                let msg = "SQLiteDB - failed to prepare SQL: \(sql), Error: \(error)"
                print(msg)
            }
            return false
        }
        // 准备参数
        let cCourseName = course.courseName!.cString(using: String.Encoding.utf8)
        let cTeacher = course.teacher!.cString(using: String.Encoding.utf8)
        let cClassroom = course.classroom!.cString(using: String.Encoding.utf8)
        let cStart = Int32(Int(course.start!))
        let cEnd = Int32(Int(course.end!))
        let cDay = Int32(Int(course.day!))
        let cWeeks = Int32(Int(course.weeks!))
        
        // 绑定參数
        sqlite3_bind_text(stmt, 1, cCourseName, -1, nil)
        sqlite3_bind_text(stmt, 2, cTeacher, -1, nil)
        sqlite3_bind_text(stmt, 3, cClassroom, -1, nil)
        sqlite3_bind_int(stmt, 4, cStart)
        sqlite3_bind_int(stmt, 5, cEnd)
        sqlite3_bind_int(stmt, 6, cDay)
        sqlite3_bind_int(stmt, 7, cWeeks)
        
        // 执行插入
        if sqlite3_step(stmt) != SQLITE_DONE {
            sqlite3_finalize(stmt)
            print("插入数据失败。")
            return false
        }
        // 释放语句对象
        sqlite3_finalize(stmt)
        // 关闭数据库(你在这里提前关闭了数据库，之后怎么可能执行成功？？？)
//        sqlite3_close(db)
        print("插入数据成功")
        return true
    }
    
    // 查询所有课程
    func getAllCourse() -> [BWCourse] {
        // 声明一个Course对象数组（查询的信息会添加到该数组）
        var courseArray = [BWCourse]()
        
        // sql
        let sql = "SELECT courseName,teacher,classroom,start,end,day,weeks FROM BWCourseTable"
        
        // sqlite3_stmt 指针
        var stmt: OpaquePointer? = nil
        
        
        // 编译sql
        let prepareResult = sqlite3_prepare_v2(db, sql, -1, &stmt, nil)
        if prepareResult != SQLITE_OK {
            sqlite3_finalize(stmt)
            if let error = sqlite3_errmsg(db) {
                let msg = "SQLiteDB - failed to prepare SQL: \(sql), Error: \(error)"
                print(msg)
            }
            return courseArray
        }
        
        // 查询
        while sqlite3_step(stmt) == SQLITE_ROW {
            let course = BWCourse()
            // 循环从数据库获取数据并添加到数组中
            let cCourseName = UnsafePointer(sqlite3_column_text(stmt, 0))
            let cTeacher = UnsafePointer(sqlite3_column_text(stmt, 1))
            let cClassroom = UnsafePointer(sqlite3_column_text(stmt, 2))
            let cStart = sqlite3_column_int(stmt, 3)
            let cEnd = sqlite3_column_int(stmt, 4)
            let cDay = sqlite3_column_int(stmt, 5)
            let cWeeks = sqlite3_column_int(stmt, 6)
            course.courseName = String.init(cString: cCourseName!)
            course.teacher = String.init(cString: cTeacher!)
            course.classroom = String.init(cString: cClassroom!)
            course.start = Int(cStart)
            course.end = Int(cEnd)
            course.day = Int(cDay)
            course.weeks = Int(cWeeks)
            
            courseArray.append(course)
        }
        
        sqlite3_finalize(stmt)
        
        return courseArray
    }
    
    // MARK: - 清空课表
    func cleanTable() -> Bool {
        print("清空课表ing")
        // sql
        let sql = "DELETE FROM BWCourseTable;"
        
        // sqlite3_stmt 指针
        var stmt: OpaquePointer? = nil
        
        // 编译sql
        let prepareResult = sqlite3_prepare_v2(db, sql, -1, &stmt, nil)
        if prepareResult != SQLITE_OK {
            sqlite3_finalize(stmt)
            if let error = sqlite3_errmsg(db) {
                let msg = "SQLiteDB - failed to prepare SQL: \(sql), Error: \(error)"
                print(msg)
            }
            print("清空失败")
            return false
        }
        // step执行
        let stepResult = sqlite3_step(stmt)
        // 判断执行结果，如果失败，获取失败信息
        if stepResult != SQLITE_OK && stepResult != SQLITE_DONE {
            sqlite3_finalize(stmt)
            if sqlite3_errmsg(stmt) != nil {
                let msg = "SQLiteDB - failed to execute SQL:\(sql)"
                print(msg)
            }
            return false
        }
        //
        sqlite3_finalize(stmt)
        print("清空成功")
        return true
    }

}
