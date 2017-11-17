//
//  BWDBManager.swift
//  BestWay
//
//  Created by solar on 17/7/24.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import Foundation
import FMDB
// TODO: - 数据库单例、建表
class BWDBManager: NSObject {
    // 单例
    static let shareInstance = BWDBManager()
    var dbQueue: FMDatabaseQueue?
    // 打开数据库
    func openDB(_ dbName: String) {
        // 拼接路径
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        dbQueue = FMDatabaseQueue(path: "\(path)/\(dbName)")
        createTable()
    }
    func createTable() {
        // 编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS BW_COURSE(\n"+"id INTEGER PRIMARY KEY AUTOINCREMENT,\n"+"courseName TEXT,\n"+"teacher TEXT,\n"+"classroom TEXT,\n"+"start INTEGER,\n"+"end INTEGER,\n"+"day INTEGER,\n"+"week INTEGER,\n);"
        // 执行SQL语句
        dbQueue?.inDatabase({ (db) -> Void in
            try! db?.executeUpdate(sql, values: [])
        })
    }
}
