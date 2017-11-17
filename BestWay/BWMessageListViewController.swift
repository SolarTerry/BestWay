//
//  MessageListViewController.swift
//  BestWay
//
//  Created by 万志强 on 16/12/10.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit

// 消息列表控制器
class BWMessageListViewController: RCConversationListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDisplayConversationTypes([
            RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue,
            RCConversationType.ConversationType_CUSTOMERSERVICE.rawValue,
            RCConversationType.ConversationType_PUBLICSERVICE.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_PUSHSERVICE.rawValue,
            RCConversationType.ConversationType_CHATROOM.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue
            ])
//        self.refreshConversationTableViewIfNeeded()
        
        self.conversationListTableView.separatorStyle = .none
        self.conversationListTableView.backgroundColor = UIColor(red: 0.96247226, green: 0.9624947906, blue: 0.9624827504, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        
        let conversationViewController = BWConversationViewController(conversationType: model.conversationType, targetId: model.targetId!)
        conversationViewController?.title = model.conversationTitle
        

        self.navigationController?.pushViewController(conversationViewController!, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
