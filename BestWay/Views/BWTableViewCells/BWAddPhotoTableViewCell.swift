//
//  BWAddPhotoTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/4/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import Photos

// 添加图片组件cell
class BWAddPhotoTableViewCell: UITableViewCell, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    // 存放图片的数组
    var imageArray = [UIImage]()
    
    // 存放图片的collectionview
    var collectionView: UICollectionView!
    
    // 最大图片张数
    let maxImageCount = 9
    
    // 添加图片按钮
    var addButton: UIButton!
    
    // 选择上传图片方式弹窗
    var addImageAlertController: UIAlertController!
    
    // 缩略图大小
    var imageSize: CGSize!
    
    // 所在的视图控制器
    var vc: UIViewController!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 获取缩略图的大小
        let cellSize = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        self.imageSize = cellSize
        self.collectionView.frame = CGRect(x: 10, y: 35, width: 200, height: self.frame.size.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 设置添加图片按钮相关属性
        addButton = UIButton(type: UIButtonType.custom)
        addButton.setTitle("添加图片", for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addItem(_:)), for: UIControlEvents.touchUpInside)
        addButton.backgroundColor = UIColor.init(red: 164 / 255, green: 193 / 255, blue: 244 / 255, alpha: 1)
        addButton.frame = CGRect(x: 10, y: 5, width: 100, height: 25)
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 8.0
        
        // 设置collection的layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        // 列间距
        layout.minimumInteritemSpacing = 10
        // 行间距
        layout.minimumLineSpacing = 10
        // 偏移量
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        // 设置collectionview的大小、背景色、代理、数据源
        collectionView = UICollectionView(frame: CGRect(x: 10, y: 35, width: 200, height: self.frame.size.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 注册cell
        collectionView.register(BWAddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        
        // 选择上传照片方式的弹窗设置
        addImageAlertController = UIAlertController(title: "请选择上传方式", message: "hh", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) in self.cameraAction()
        })
        let albumAction = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) in self.albumAction()
        })
        self.addImageAlertController.addAction(cancelAction)
        self.addImageAlertController.addAction(cameraAction)
        self.addImageAlertController.addAction(albumAction)
        
        self.addSubview(addButton)
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - 添加图片按钮监听方法
    func addItem(_ button: UIButton) {
        self.vc = responderViewController()
        vc?.present(addImageAlertController, animated: true, completion: nil)
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
    
    // MARK: - 拍照监听方法
    func cameraAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // 创建图片控制器
            let picker = UIImagePickerController()
            
            // 设置代理
            picker.delegate = self
            
            // 设置来源
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
            // 允许编辑
            picker.allowsEditing = true
            // 打开相机
            self.vc = responderViewController()
            vc!.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else {
            print("找不到相机")
        }
    }
    
    // MARK: - 相册监听方法
    func albumAction() {
        // 可选照片数量
        let count = maxImageCount - imageArray.count
        
        self.vc = responderViewController()
        
        // 开始选择照片，最多允许选择count张
        _ = vc.presentBWAlbumImagePicker(maxSelected: count) { (assets) in
            
            // 结果处理
            for asset in assets {
                // 从asset获取image
                let image = self.PHAssetToUIImage(asset: asset)
                
                // 数据变更
                self.collectionView.performBatchUpdates({
                    let indexPath = IndexPath(item: self.imageArray.count, section: 0)
                    let arr = [indexPath]
                    self.collectionView.insertItems(at: arr)
                    self.imageArray.append(image)
                }, completion: {(completion) in
                    self.collectionView.reloadData()
                })
                
                // 判断是否使添加图片按钮失效
                if self.imageArray.count > 8 {
                    self.addButton.isEnabled = false
                    self.addButton.backgroundColor = UIColor.darkGray
                }
            }
        }
    }
    
    // MARK: - 将PHAsset对象转为UIImage对象
    func PHAssetToUIImage(asset: PHAsset) -> UIImage {
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: self.imageSize, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }
    
    // MARK: - 删除图片按钮监听方法
    func removeItem(_ button: UIButton) {
        // 数据变更
        self.collectionView.performBatchUpdates({
            self.imageArray.remove(at: button.tag)
            let indexPath = IndexPath(item: button.tag, section: 0)
            let arr = [indexPath]
            self.collectionView.deleteItems(at: arr)
        }, completion: {(completion) in
            self.collectionView.reloadData()
        })
        
        // 判断是否使添加图片按钮生效
        if imageArray.count < 9 {
            self.addButton.isEnabled = true
            self.addButton.backgroundColor = UIColor.init(red: 164 / 255, green: 193 / 255, blue: 244 / 255, alpha: 1)
        }
    }
    
    // MARK: - 相机图片选择器
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 将相机刚拍好的照片拿出来
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 数据变更
        self.collectionView.performBatchUpdates({
            let indexPath = IndexPath(item: self.imageArray.count, section: 0)
            let arr = [indexPath]
            self.collectionView.insertItems(at: arr)
            self.imageArray.append(gotImage)
            print(self.imageArray.count)
            
        }, completion: {(completion) in
            self.collectionView.reloadData()
        })
        
        // 判断是否使添加图片按钮失效
        if imageArray.count > 8 {
            self.addButton.isEnabled = false
            self.addButton.backgroundColor = UIColor.darkGray
        }
        
        // 关闭此页面
        self.vc.dismiss(animated: true, completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - collection代理方法实现
extension BWAddPhotoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 每个区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    // 分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 自定义cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! BWAddPhotoCollectionViewCell
        cell.imageView.image = imageArray[indexPath.item]
        cell.button.addTarget(self, action: #selector(removeItem(_:)), for: UIControlEvents.touchUpInside)
        cell.button.tag = indexPath.row
        return cell
    }
    
    // 是否可以移动
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
