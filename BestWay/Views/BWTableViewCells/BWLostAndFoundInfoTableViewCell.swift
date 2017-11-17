//
//  BWLostAndFoundInfoTableViewCell.swift
//  BestWay
//
//  Created by solar on 17/4/20.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
// 失物招领列表cell
class BWLostAndFoundInfoTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - 用户头像
    @IBOutlet weak var userLogoImageView: UIImageView!
    
    // MARK: - 用户名
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - 发布时间
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - 内容
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - 配图
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    
    // MARK: - 配图view高度
    @IBOutlet weak var picturesCollectionViewHeight: NSLayoutConstraint!
    
    // MARK: - 内容view高度
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    
    // MARK: - 图片名称数组
    var pictures:[UIImage] = []
    
    // MARK: - 背景图
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - 更多功能按钮
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: - 继承collectionView的delegate和dataSource
        self.picturesCollectionView.delegate = self
        self.picturesCollectionView.dataSource = self
        
        // MARK: - 注册BWImageCollectionViewCell
        self.picturesCollectionView.register(UINib(nibName:"BWImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    // MARK: - 重新加载数据
    func reloadData(tableViewType: Int,userLogoImage: UIImage, username: String, time: String, item: String, phone: String, note: String, pictures: [UIImage]) {
        self.userLogoImageView.image = userLogoImage
        self.usernameLabel.text = username
        self.timeLabel.text = time
        
        // MARK: - 使UILabel里的文字换行
        self.contentLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        self.contentLabel.numberOfLines = 0
        if tableViewType == 1 {
            self.contentLabel.text = "丢失物品: \(item)\n联系电话: \(phone)\n备  注: \(note)"
        }
        if tableViewType == 2 {
            self.contentLabel.text = "拾到物品: \(item)\n联系电话: \(phone)\n备  注: \(note)"
        }
        
        // MARK: - 使UILabel根据文字内容自适应高度
        let contentLabelText: NSString = self.contentLabel.text! as NSString
        let attributes = [NSFontAttributeName: self.contentLabel.font!]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let contentLabelSize = contentLabelText.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: 0), options: options, attributes: attributes, context: nil)
        self.contentLabelHeight.constant = contentLabelSize.height
        
        self.pictures = pictures
        
        // MARK: - 刷新collection获取最新高度
        self.picturesCollectionView.reloadData()
        let contentSize = self.picturesCollectionView.collectionViewLayout.collectionViewContentSize
        picturesCollectionViewHeight.constant = contentSize.height
        
    }
    
    // MARK: - 单元格数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // MARK: - 单元格创建
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = picturesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BWImageCollectionViewCell
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
    func imageViewTap(_ recognizer:UITapGestureRecognizer) {
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
