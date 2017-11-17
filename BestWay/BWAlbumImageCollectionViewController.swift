//
//  BWAlbumImageCollectionViewController.swift
//  BestWay
//
//  Created by solar on 17/4/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import Photos

// 图片缩略图集合页控制器
class BWAlbumImageCollectionViewController: UIViewController {
    // MARK: - 用于显示所有图片缩略图的collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - 下方工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: - 取得的资源结果，用了存放的PHAsset
    var assetsFetchResults: PHFetchResult<PHAsset>!
    
    // MARK: - 带缓存的图片管理对象
    var imageManager: PHCachingImageManager!
    
    // MARK: - 缩略图大小
    var assetGridThumbnailSize: CGSize!
    
    // MARK: - 每次最多可选择的照片数量
    var maxSelected: Int = Int.max
    
    // MARK: - 照片选择完毕后的回调
    var completeHandler: ((_ assets: [PHAsset])->())?
    
    // MARK: - 完成按钮
    var completeButton: BWAlbumImageCompleteButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 根据单元格的尺寸计算我们需要的缩略图大小
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // 背景色设置为白色（默认是黑色）
        self.collectionView.backgroundColor = UIColor.white
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        
        // 设置单元格尺寸
        let layout = (self.collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4-1,
                                 height: UIScreen.main.bounds.size.width/4-1)
        // 允许多选
        self.collectionView.allowsMultipleSelection = true
        
        // 添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain,
                                           target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        // 添加下方工具栏的完成按钮
        completeButton = BWAlbumImageCompleteButton()
        completeButton.addTarget(target: self, action: #selector(finishSelect))
        completeButton.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: 22)
        completeButton.isEnabled = false
        toolBar.addSubview(completeButton)
    }
    
    // MARK: - 重置缓存
    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    // MARK: - 取消按钮点击
    func cancel() {
        // 退出当前视图控制器
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 获取已选择个数
    func selectedCount() -> Int {
        return self.collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    // MARK: - 完成按钮点击
    func finishSelect(){
        // 取出已选择的图片资源
        var assets:[PHAsset] = []
        if let indexPaths = self.collectionView.indexPathsForSelectedItems{
            for indexPath in indexPaths{
                assets.append(assetsFetchResults[indexPath.row] )
            }
        }
        // 调用回调函数
        self.navigationController?.dismiss(animated: true, completion: {
            self.completeHandler?(assets)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// BWAlbumImageCollectionViewController的UICollectionViewDelegate、UICollectionViewDataSource代理方法实现
extension BWAlbumImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - CollectionView项目
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    
    // MARK: - 获取单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 获取storyboard里设计的单元格，不需要再动态添加界面元素
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumImageCell", for: indexPath) as! BWAlbumImageCollectionViewCell
        let asset = self.assetsFetchResults[indexPath.row]
        // 获取缩略图
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: .aspectFill, options: nil) {
            (image, _) in
            cell.imageView.image = image
        }
        return cell
    }
    
    // MARK: - 单元格选中响应
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BWAlbumImageCollectionViewCell {
            // 获取选中的数量
            let count = self.selectedCount()
            // 如果选择的个数大于最大选择数
            if count > self.maxSelected {
                // 设置为不选中状态
                collectionView.deselectItem(at: indexPath, animated: false)
                // 弹出提示
                let title = "你最多只能选择\(self.maxSelected)张照片"
                let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title:"我知道了", style: .cancel, handler:nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
                // 如果不超过最大选择数
            else{
                // 改变完成按钮数字，并播放动画
                completeButton.num = count
                if count > 0 && !self.completeButton.isEnabled{
                    completeButton.isEnabled = true
                }
                cell.playAnimate()
            }
        }
    }
    
    // MARK: - 单元格取消选中响应
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BWAlbumImageCollectionViewCell {
            // 获取选中的数量
            let count = self.selectedCount()
            completeButton.num = count
            // 改变完成按钮数字，并播放动画
            if count == 0{
                completeButton.isEnabled = false
            }
            cell.playAnimate()
        }
    }
}
