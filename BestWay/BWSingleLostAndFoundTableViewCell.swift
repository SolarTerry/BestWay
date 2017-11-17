//
//  BWSingleLostAndFoundTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/5/11.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 单人失物招领页面单条信息cell
class BWSingleLostAndFoundTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - 背景图
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - 信息label
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - 配图collectionview
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // MARK: - 信息label高度
    @IBOutlet weak var infoLabelHeight: NSLayoutConstraint!
    
    // MARK: - 配图collectionview高度
    @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
    
    // MARK: - 图片名称数组
    var pictures:[UIImage] = []
    
    // MARK: - 发布时间label
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // MARK: - 继承collectionView的delegate和dataSource
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        
        // MARK: - 注册BWImageCollectionViewCell
        self.imageCollectionView.register(UINib(nibName:"BWImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    // MARK: - 单元格数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // MARK: - 单元格创建
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BWImageCollectionViewCell
        cell.pictureImageView.image = pictures[indexPath.item]
        cell.pictureImageView.tag = indexPath.item
        cell.pictureImageView.contentMode = .scaleAspectFit
        cell.pictureImageView.clipsToBounds = true
        
        // MARK: - 设置允许交互
        cell.pictureImageView.isUserInteractionEnabled = true
        
        // MARK: - 添加缩略图单击监听
        let tapSingle = UITapGestureRecognizer(target: self, action: #selector(imageViewTap(_:)))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        cell.pictureImageView.addGestureRecognizer(tapSingle)
        
        return cell
    }
    
    // MARK: - 缩略图点击处理方法
    func imageViewTap(_ recognizer: UITapGestureRecognizer) {
        // MARK: - 图片索引
        let index = recognizer.view!.tag
        
        // MARK: - 进入图片全屏展示
        let previewVC = BWImagePreviewViewController(images: pictures, index: index)
        let vc = self.responderViewController()
        vc?.present(previewVC, animated: true, completion: nil)
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
    
    // MARK: - 重新加载数据
    func reloadData(type: Int, time: String, item: String, phone: String , note: String, pictures: [UIImage]) {
        self.timeLabel.text = time
        
        // 使UILabel里的文字换行
        self.infoLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        self.infoLabel.numberOfLines = 0
        if type == 1 {
            self.infoLabel.text = "丢失物品: \(item)\n联系电话: \(phone)\n备  注: \(note)"
        }else {
            self.infoLabel.text = "拾到物品: \(item)\n联系电话: \(phone)\n备  注: \(note)"
        }
        
        // 使UILabel根据文字内容自适应高度
        let infoLabelText: NSString = self.infoLabel.text! as NSString
        let attributes = [NSFontAttributeName: self.infoLabel.font!]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let infoLabelSize = infoLabelText.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: 0), options: options, attributes: attributes, context: nil)
        self.infoLabelHeight.constant = infoLabelSize.height
        
        self.pictures = pictures
        
        // 刷新collection获取最新高度
        self.imageCollectionView.reloadData()
        let contentSize = self.imageCollectionView.collectionViewLayout.collectionViewContentSize
        self.imageCollectionViewHeight.constant = contentSize.height
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
