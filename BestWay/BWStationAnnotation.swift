//
//  BWStationAnnotation.swift
//  BestWay
//
//  Created by 万志强 on 17/3/2.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import Foundation

class BWStationAnnotation: NSObject,MAAnnotation {
    // MARK: - 车站名
    var title: String!
    
    // MARK: - 车站副标题
    var subtitle: String!
    
    // MARK: - 车站坐标
    var coordinate: CLLocationCoordinate2D
    
    // MARK: - 车站id
    var stationId: String!
    
    // MARK: - 初始化方法
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
