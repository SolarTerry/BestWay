//
//  BWImageUtil.swift
//  BestWay
//
//  Created by 万志强 on 16/12/3.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import Foundation
// 图片类公共工具类
class BWImageUtil {
    // MARK: - 图片等比例压缩
    static func scaleImage(_ image:UIImage,scaledToSize newSize:CGSize) -> UIImage {
        var width:CGFloat!
        var height:CGFloat!
        // 等比例缩放
        if image.size.width/newSize.width >= image.size.height / newSize.height{
            width = newSize.width
            height = image.size.height / (image.size.width/newSize.width)
        }else{
            height = newSize.height
            width = image.size.width / (image.size.height/newSize.height)
        }
        let sizeImageSmall = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(sizeImageSmall);
        image.draw(in: CGRect(x: 0,y: 0,width: sizeImageSmall.width,height: sizeImageSmall.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage;
    }
}
