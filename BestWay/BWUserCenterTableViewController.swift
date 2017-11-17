//
//  UserCenterTableViewController.swift
//  BestWay
//
//  Created by 万志强 on 16/11/6.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
import Alamofire
import SVProgressHUD
import Qiniu
import SwiftyJSON

// MARK: - Cell中的Label Tag
enum CellLabelTag:Int {
    case realName = 4,username,college,major,phone,email
}

// 用户个人信息页面控制器
class BWUserCenterTableViewController: UITableViewController {
    
    // MARK: - 用户头像
    let USER_LOGO_TAG = 1
    
    // MARK: - 昵称Tag
    let NICK_NAME_TAG = 2
    
    // MARK: - 性别图标Tag
    let SEX_IMAGE_TAG = 3
    
    // MARK: - 用户头像View
    var userLogoView:UIImageView?
    
    // MARK: - 用户昵称输入框
    var nickNameField:UITextField?
    
    // MARK: - 点击手势
    var tapGR:UITapGestureRecognizer?
    
    // MARK: - 用户信息
    var user:BWUser?
    
    // MARK: - 用户名
    let username = UserDefaults.standard.string(forKey: "username")
    
    // MARK: - 左侧图标集合
    let infoIconList = ["cell-icon-name",
                    "cell-icon-id",
                    "cell-icon-academy",
                    "cell-icon-major",
                    "cell-icon-phone",
                    "cell-icon-email"
    ]
    
    // MARK: - 设置图标集合
    let settingIconList = ["cell-icon-setting",
                           "",
                           ""
    ]
    
    // MARK: - Cell名称集合
    let infoCellNameList = ["姓名：",
                            "学号：",
                            "学院：",
                            "专业：",
                            "电话：",
                            "邮箱："
    ]
    
    // MARK: - 设置cell名称集合
    let settingCellNameList = ["设置",
                               "",
                               ""
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 隐藏导航栏
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 2:
            return 144
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "default")
        let userLogoCell = tableView.dequeueReusableCell(withIdentifier: "userLogo")

        // 如果为第一个cell，则在顶部添加一条直线作为边框
        if indexPath.row == 0 {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5))
            line.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            
            defaultCell?.addSubview(line)
            
        }
        
        // 如果为最后一个cell，则在底部添加一条直线作为边框
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            let underline = UIView(frame: CGRect(x: 0, y: 43.5, width: self.view.frame.size.width, height: 0.5))
            underline.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            defaultCell?.addSubview(underline)
        }
        
        switch indexPath.section {
        case 0:
            userLogoCell?.selectionStyle = .none
            
            userLogoView = userLogoCell?.viewWithTag(USER_LOGO_TAG) as! UIImageView?
            userLogoView?.layer.cornerRadius = (userLogoView?.frame.size.width)! / 2
            userLogoView?.layer.masksToBounds = true
            userLogoView?.isUserInteractionEnabled = true
            tapGR = UITapGestureRecognizer(target: self, action: #selector(BWUserCenterTableViewController.selectImg(_:)))
            userLogoView?.addGestureRecognizer(tapGR!)
            
            // 尝试从本地获取头像,否则从网络重新获取
            let userLogoData = UserDefaults.standard.data(forKey: "userLogo")
            if userLogoData != nil {
                let userLogo = UIImage(data: userLogoData!)
                userLogoView?.image = userLogo
            } else {
                let requestUtil = BWRequestUtil.shareInstance
                
                requestUtil.sendRequestResponseData(BWApiurl.getUerImageUrl(username!), method: .get, parameters: [:], completionHandler: { (response) in

                    if NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) != nil {
                        self.userLogoView?.image = UIImage(named: "user-default-logo")
                        return
                    }
                    let image = UIImage(data: response.data!)
                    self.userLogoView?.image = image
                })
            }
            
            // 初始化昵称输入框
            nickNameField = UITextField(frame: CGRect(x: (self.view.frame.width - 220) / 2, y: (userLogoView?.frame.maxY)! + 10, width: 220, height: 20))
            nickNameField?.tag = NICK_NAME_TAG
            nickNameField?.textAlignment = .center
            nickNameField?.adjustsFontSizeToFitWidth = true
            nickNameField?.textColor = UIColor.white
            nickNameField?.text = "点击修改昵称"
            
            userLogoCell?.addSubview(nickNameField!)
            
            return userLogoCell!
            
        case 1:
            // cell左边的图标
            let leftImageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 44 - 12 * 2, height: 44 - 12 * 2))
            leftImageView.image = UIImage(named: self.infoIconList[indexPath.row])
            
            // 左侧Label
            let leftLabel = UILabel(frame: CGRect(x: Int(leftImageView.frame.maxX + leftImageView.frame.size.width), y: 0, width: 45, height: 44))
            leftLabel.adjustsFontSizeToFitWidth = true
            leftLabel.text = infoCellNameList[indexPath.row]
            
            // 用户信息显示Label
            let infoLabel = UILabel(frame: CGRect(x: leftLabel.frame.maxX + 10, y: 0, width: 125, height: 44))
            infoLabel.adjustsFontSizeToFitWidth = true
            infoLabel.textColor = UIColor.darkGray
            infoLabel.tag = CellLabelTag.realName.rawValue + indexPath.row
            
            // 如果为第一个cell，添加性别图标
            if indexPath.row == 0 {
                // 性别图标
                let sexImageView = UIImageView(frame: CGRect(x: self.view.frame.size.width - 40, y: 12, width: 20, height: 20))
                sexImageView.tag = SEX_IMAGE_TAG
                
                defaultCell?.addSubview(sexImageView)
                
            }

            defaultCell?.addSubview(infoLabel)
            defaultCell?.addSubview(leftLabel)
            defaultCell?.addSubview(leftImageView)
            
            return defaultCell!
            
        case 3:
            // cell左边的图标
            let leftImageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 44 - 12 * 2, height: 44 - 12 * 2))
            leftImageView.image = UIImage(named: settingIconList[indexPath.row])
            
            // 左侧Label
            let leftLabel = UILabel(frame: CGRect(x: Int(leftImageView.frame.maxX + leftImageView.frame.size.width), y: 0, width: 45, height: 44))
            leftLabel.adjustsFontSizeToFitWidth = true
            leftLabel.text = settingCellNameList[indexPath.row]
            
            defaultCell?.addSubview(leftImageView)
            defaultCell?.addSubview(leftLabel)
            
            defaultCell?.accessoryType = .disclosureIndicator

            return defaultCell!
        default:
            defaultCell?.frame = CGRect(x: 20, y: 0, width: 200, height: 30)
            return defaultCell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "settingSegue", sender: nil)
            default:
                return
            }
        default:
            return
        }
    }
    
    
    // MARK: - 向下拉动时设置Y坐标为0，实现禁止下拉页面的效果
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offY = scrollView.contentOffset.y
        
        if offY < 0 {
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        }
        
    }
    
    
    // MARK: - 图片选择方法
    func selectImg(_ sender:UITapGestureRecognizer) {
        
        // 获取相册权限状态
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        if authStatus == .denied || authStatus == .restricted {
            let alertController = UIAlertController.alertControllerWithAction("警告", msg: "没有照片访问权限，请在设置 -> 隐私 -> 照片 中允许本程序访问", actionTitle: "设置") { (UIAlertAction) in
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let pickerController = UIImagePickerController()
            pickerController.allowsEditing = true
            pickerController.sourceType = .photoLibrary
            pickerController.delegate = self
            
            let alertViewController = UIAlertController.alertControllerWithActionNoCancel("消息", msg: "选一张漂亮的照片作为头像吧😄", actionTitle: "好的", action: { (UIAlertAction) in
                self.navigationController?.present(pickerController, animated: true, completion: {
                    
                })
            })
            
            self.present(alertViewController, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - 获取用户基本信息
    func retrieveUserInfo() {
        let requestUtil = BWRequestUtil.shareInstance
        let userData = UserDefaults.standard.data(forKey: "BWUser")
        
        // 尝试从本地获取用户信息
        if userData != nil {
            user = (NSKeyedUnarchiver.unarchiveObject(with: userData!) as! BWUser)
            
            // 设置页面内信息显示
            setUserInfo()
            return
        }
        requestUtil.sendRequestResponseJSON(BWApiurl.GET_USER_INFO, method: .post, parameters: [:]) { response in
            SVProgressHUD.show(withStatus: "数据加载中...")
            var data = JSON(data: response.data!)
            
            // 返回数据为空
            if data == JSON.null {
                SVProgressHUD.showError(withStatus: "服务器异常！")
                return
            }
            
            var info = data["data"]
            
            // 返回的Message信息
            let message = data["message"].stringValue
            
            // 返回的Code
            let code = data["code"].intValue
            
            switch code {
            case 0:
                // 解析出JSON中信息
                let id = info["id"].intValue
                let realName = info["realName"].stringValue
                let password = info["password"].stringValue
                let nickname = info["nickname"].stringValue
                let college = info["college"].stringValue
                let email = info["email"].stringValue
                let grade = info["grade"].stringValue
                let username = info["username"].stringValue
                let major = info["major"].stringValue
                let sex = info["sex"].intValue
                let phone = info["phone"].stringValue
                let birthday = info["birthday"].stringValue
                let createTime = info["createTime"].stringValue
                
                // 写入User Model
                self.user = BWUser(id: id, username: username, password: password, nickname: nickname, college: college, major: major, grade: grade, birthday: birthday, phone: phone, email: email, realName: realName, sex: sex, createTime: createTime)
                
                
                // 将User对象序列化为NSData存进NSUserDefaults
                let userdata:Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                UserDefaults.standard.set(userdata, forKey: "BWUser")
                
                // 设置页面内信息显示
                self.setUserInfo()
                SVProgressHUD.showSuccess(withStatus: "获取成功")
            default:
                SVProgressHUD.showError(withStatus: message)
            }
            
        }
        
    }
    
    // MARK: - 将用户信息填入Cell中
    func setUserInfo() {
        // 获取用户信息的全部Cell
        let cellRealNameLabel = self.view.viewWithTag(CellLabelTag.realName.rawValue) as! UILabel
        let cellUsernameLabel = self.view.viewWithTag(CellLabelTag.username.rawValue) as! UILabel
        let cellCollegeLabel = self.view.viewWithTag(CellLabelTag.college.rawValue) as! UILabel
        let cellMajorLabel = self.view.viewWithTag(CellLabelTag.major.rawValue) as! UILabel
        let cellPhoneLabel = self.view.viewWithTag(CellLabelTag.phone.rawValue) as! UILabel
        let cellEmailLabel = self.view.viewWithTag(CellLabelTag.email.rawValue) as! UILabel
        
        // 根据性别设置图标
        let sexImageView = self.view.viewWithTag(SEX_IMAGE_TAG) as! UIImageView
        sexImageView.image = UIImage(named: (user?.sex == 1 ? "sex_male":"sex_female"))
        
        // 填充用户信息
        cellRealNameLabel.text = self.user?.realName
        cellUsernameLabel.text = self.user?.username
        cellCollegeLabel.text = self.user?.college
        cellMajorLabel.text = self.user?.major
        cellPhoneLabel.text = self.user?.phone
        cellEmailLabel.text = self.user?.email
        
    }
}

// MARK: - BWUserCenterTableViewController的UIImagePickerControllerDelegate扩展方法
extension BWUserCenterTableViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    // MARK: - 选择图片后的处理方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let userLogoView = self.view.viewWithTag(USER_LOGO_TAG) as! UIImageView?

        // 获取选择的原图
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 压缩后的图片
        let scaledImage = BWImageUtil.scaleImage(selectedImage, scaledToSize: CGSize(width: 110 * 3, height: 110 * 3))
        
        userLogoView?.image = scaledImage
        
        // 将图片转化Data，以便上传七牛
        let imageData = UIImagePNGRepresentation(scaledImage)
        
        // 将用户头像储存在本地
        UserDefaults.standard.set(imageData, forKey: "userLogo")
        
        // 上传图片
        self.uploadImage(imageData!)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - 点击取消按钮处理方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ imageData:Data) {
        // 七牛Token
        var qiniuToken = ""
        
        // 七牛上传工具
        let qiniuUtil = QNUploadManager()
        
        let requestUtil = BWRequestUtil.shareInstance
        
        // 设置SVProgressHUD的遮罩层，禁止用户操作
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "准备中...")
        
        // 设置七牛上传进度的回调方法
        let option = QNUploadOption(mime: nil, progressHandler: { (key, percent) in
            SVProgressHUD.showProgress(percent, status: "正在上传...")
        }, params: nil, checkCrc: false, cancellationSignal: nil)
        
        // 从业务服务器获取Token
        requestUtil.sendRequestResponseData(BWApiurl.GET_QINIU_TOKEN, method: .get, parameters: [:]) { response in
            
            qiniuToken = NSString.init(data: response.data!, encoding: String.Encoding.utf8.rawValue) as! String
            
            // 删除用户之前的头像，成功后发起七牛上传请求
            requestUtil.sendRequestResponseJSON(BWApiurl.DELETE_QINIU_FILE, method: .post, parameters: ["key": "userlogo/\(self.username!).png"]){ response in
                if qiniuToken != "" {
                    qiniuUtil?.put(imageData, key: "userlogo/\(self.username!).png", token: qiniuToken, complete: { (info, key, response) in
                        if response != nil {
                            SVProgressHUD.showSuccess(withStatus: "上传成功！")
                        }
                    }, option: option )
                }
            }
        }
    }
}
// MARK: - 实现BWUserCenterTableViewController的UITextFieldDelegate代理方法
extension BWUserCenterTableViewController:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case NICK_NAME_TAG:
            // TODO: - 修改用户昵称
            break
        default:
            return
        }
    }
}



