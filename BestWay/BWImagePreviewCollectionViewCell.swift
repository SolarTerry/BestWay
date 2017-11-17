//
//  BWImagePreviewCollectionViewCell.swift
//  BestWay
//
//  Created by solar on 17/4/20.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 图片大图预览cell
class BWImagePreviewCollectionViewCell: UICollectionViewCell {
    // MARK: - 滚动视图
    var scrollView: UIScrollView!
    
    // MARK: - 用于显示图片的imageView
    var imageView: UIImageView!
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: - scrollView初始化
        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.contentView.addSubview(scrollView)
        scrollView.delegate = self
        
        // MARK: - scrollView缩放范围1~3
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        // MARK: - imageView初始化
        imageView = UIImageView()
        imageView.frame = scrollView.bounds
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        // MARK: - 单击监听
        let tapSingle = UITapGestureRecognizer(target: self, action: #selector(tapSingleDid(_:)))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        self.imageView.addGestureRecognizer(tapSingle)
    }
    
    // MARK: - 重置单元格内元素尺寸
    func resetSize() {
        
        // MARK: - scrollView重置，不缩放
        scrollView.zoomScale = 1.0
        
        // MARK: - imageView重置
        if let image = self.imageView.image {
            // MARK: - 设置imageView的尺寸使一个屏幕能显示完
            imageView.frame.size = scaleSize(size: image.size)
            
            // MARK: - 使图片居中
            imageView.center = scrollView.center
        }
    }
    
    // MARK: - 获取imageView的缩放尺寸，确保首次显示可以是一张完整的图片
    func scaleSize(size: CGSize) -> CGSize {
        let width = size.width
        let height = size.height
        let widthRatio = width / UIScreen.main.bounds.width
        let heightRatio = height / UIScreen.main.bounds.height
        let ratio = max(heightRatio, widthRatio)
        return CGSize(width: width / ratio, height: height / ratio)
    }
    
    // MARK: - 图片单击事件处理
    func tapSingleDid(_ ges: UITapGestureRecognizer) {
        let vc = self.responderViewController()
        vc?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 查找所在的ViewController
    func responderViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - BWImagePreviewCollectionViewCell的UIScrollViewDelegate代理实现
extension BWImagePreviewCollectionViewCell: UIScrollViewDelegate {
    // MARK: - 缩放视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    // MARK: - 缩放响应，设置imageView的中心位置
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}
