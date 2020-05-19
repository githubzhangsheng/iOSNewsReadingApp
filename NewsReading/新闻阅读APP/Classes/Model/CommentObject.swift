//
//  Comment.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 评论模型
class CommentObject: NSObject {
    /// 评论用户uid
    var userid: String?
    /// 创建时间
    var create_time: String?
    /// 用户昵称
    var nickname: String?
    /// 评论内容
    var content: String?
    /// 用户头像地址
    var avatar: String?
    
    init(jsonData: JSON) {
        super.init()
        self.userid = jsonData["userid"].string
        self.create_time = jsonData["create_time"].string
        self.nickname = jsonData["nickname"].string
        self.avatar = jsonData["avatar"].string
        self.content = jsonData["content"].string
    }
}
