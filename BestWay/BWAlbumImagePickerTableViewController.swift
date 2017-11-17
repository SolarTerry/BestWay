//
//  BWAlbumImagePickerTableViewController.swift
//  BestWay
//
//  Created by solar on 17/4/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import Photos

// MARK: - 相簿列表项
struct AlbumItem {
    // 相簿名称
    var title:String?
    // 相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
}
// 相簿列表页控制器
class BWAlbumImagePickerTableViewController: UIViewController {
    // MARK: - 显示相簿列表项的表格
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - 相簿列表项集合
    var items: [AlbumItem] = []
    
    // MARK: - 每次最多可选择的照片数量
    var maxSelected: Int = Int.max
    
    // MARK: - 照片选择完毕后的回调
    var completeHandler: ((_ assets:[PHAsset])->())?
    
    // 从xib或者storyboard加载完毕就会调用
    override func awakeFromNib() {
        super.awakeFromNib()
        // 申请权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            
            // 列出所有系统的智能相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            // 列出所有用户创建的相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
            
            // 相册按包含的照片数量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            // 异步加载表格数据,需要在主线程中调用reloadData() 方法
            DispatchQueue.main.async{
                self.tableView?.reloadData()
                
                // 首次进来后直接进入第一个相册图片展示页面（相机胶卷）
                if let imageCollectionVC = self.storyboard?
                    .instantiateViewController(withIdentifier: "ImageCollectionVC")
                    as? BWAlbumImageCollectionViewController{
                    imageCollectionVC.title = self.items.first?.title
                    imageCollectionVC.assetsFetchResults = self.items.first?.fetchResult
                    imageCollectionVC.completeHandler = self.completeHandler
                    imageCollectionVC.maxSelected = self.maxSelected
                    self.navigationController?.pushViewController(imageCollectionVC, animated: false)
                }
            }
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置标题
        title = "相簿"
        // 设置表格相关样式属性
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = 55
        // 添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action:#selector(cancelBtnClicked) )
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - 转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        for i in 0..<collection.count{
            // 获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            
            // 没有图片的空相簿不显示
            if assetsFetchResult.count > 0 {
                let title = titleOfAlbumForChinese(title: c.localizedTitle)
                items.append(AlbumItem(title: title, fetchResult: assetsFetchResult))
            }
        }
    }
    
    // MARK: - 由于系统返回的相册集名称为英文，我们需要转换为中文
    private func titleOfAlbumForChinese(title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
    
    // MARK: - 取消按钮点击监听方法
    func cancelBtnClicked() {
        // 退出当前vc
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 页面跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 如果是跳转到展示相簿缩略图页面
        if segue.identifier == "showImages"{
            // 获取照片展示控制器
            guard let imageCollectionVC = segue.destination
                as? BWAlbumImageCollectionViewController,
                let cell = sender as? BWAlbumImagePickerTableViewCell else{
                    return
            }
            // 设置回调函数
            imageCollectionVC.completeHandler = completeHandler
            
            // 设置标题
            imageCollectionVC.title = cell.titleLabel.text
            
            // 设置最多可选图片数量
            imageCollectionVC.maxSelected = self.maxSelected
            guard  let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            // 获取选中的相簿信息
            let fetchResult = self.items[indexPath.row].fetchResult
            
            // 传递相簿内的图片资源
            imageCollectionVC.assetsFetchResults = fetchResult
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// BWAlbumImagePickerTableViewController的UITableViewDelegate、UITableViewDataSource代理方法实现
extension BWAlbumImagePickerTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - 设置单元格内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            // 同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumImagePickerCell", for: indexPath)
                as! BWAlbumImagePickerTableViewCell
            let item = self.items[indexPath.row]
            cell.titleLabel.text = "\(item.title ?? "") "
            cell.countLabel.text = "（\(item.fetchResult.count)）"
            return cell
    }
    
    // MARK: - 表格单元格数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // MARK: - 表格单元格选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// UIViewController的扩展方法
extension UIViewController {
    // MARK: - BWAlbumImagePickerTableViewController提供给外部调用的接口，同于显示图片选择页面
    func presentBWAlbumImagePicker(maxSelected:Int = Int.max, completeHandler:((_ assets:[PHAsset])->())?) -> BWAlbumImagePickerTableViewController? {
        if let vc = UIStoryboard(name: "BWAlbumImagePicker", bundle: nil).instantiateViewController(withIdentifier: "imagePickerVC") as? BWAlbumImagePickerTableViewController {
            // 设置选择完毕后的回调
            vc.completeHandler = completeHandler
            
            // 设置图片最多选择的数量
            vc.maxSelected = maxSelected
            
            // 将图片选择视图控制器外添加个导航控制器，并显示
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return vc
        }
        return nil
    }
}
