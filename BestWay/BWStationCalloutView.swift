//
//  BWStationCalloutView.swift
//  BestWay
//
//  Created by solar on 17/3/17.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit

let kArrorHeigh: CGFloat = 10.0
// 电瓶车站点弹窗
class BWStationCalloutView: UIView {
    
    override func draw(_ rect: CGRect) {
        drawInContext(UIGraphicsGetCurrentContext()!)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func drawInContext(_ context: CGContext) {
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.colorFromRGB(0x1E90FF).cgColor)
        context.setAlpha(0.7)
        drawPath(context)
        context.fillPath()
    }
    
    func drawPath(_ context: CGContext) {
        let radius:CGFloat = 6.0
        let minX    = bounds.minX
        let maxX    = bounds.maxX
        let midX    = bounds.midX
        
        let minY    = bounds.minY
        let maxY    = bounds.maxY - kArrorHeigh
        
        //开始绘制起始点 1
        context.move(to: CGPoint(x: midX + kArrorHeigh, y: maxY))
        
        //点2 和 点1 之间绘制成一条直线
        context.addLine(to: CGPoint(x: midX, y: maxY + kArrorHeigh))
        
        //点2 和 点1 之间绘制成一条直线
        context.addLine(to: CGPoint(x: midX - kArrorHeigh, y: maxY))
        
        //点3, 点4 和 点 5 之间绘制一条带弧度的直角线
        context.addArc(tangent1End: CGPoint(x: minX, y: maxY), tangent2End: CGPoint(x: minX, y:minX), radius: radius)
        
        context.addArc(tangent1End: CGPoint(x: minX,y: minX), tangent2End: CGPoint(x: maxX, y: minY), radius: radius)
        
        context.addArc(tangent1End: CGPoint(x: maxX, y: minY), tangent2End: CGPoint(x: maxX, y: maxY), radius: radius)
        
        context.addArc(tangent1End: CGPoint(x: maxX, y:maxY), tangent2End: CGPoint(x: minX, y: maxY), radius: radius)
        
        context.closePath()
    }
}
