//
//  NewsObject.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/28.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON
/// 新闻模型
class NewsObject: NSObject {
    /// 新闻id
    var id: Int = 0
    /// 新闻标题
    var title: String!
    /// 新闻信息内容(简介)
    var content: String!
    /// 新闻发表时间
    var publish_time: String!
    /// 新闻来源
    var source: String!
    /// 用户模型：即新闻作者
    var user: User?
    /// 新闻封面缩略图
    var thumb_pic: String?
    /// 点赞总数
    var totalthumbup: String = "0"
    /// 评论总数
    var totalcomments: String = "0"
    
    init(jsonData: JSON) {
        super.init()
        id = jsonData["newsid"].int ?? 0
        content = jsonData["content"].string ?? "新闻内容解析失败"
        title = jsonData["title"].string ?? "新闻标题解析失败"
        publish_time = jsonData["publish_time"].string ?? "时间解析失败"
        source = jsonData["source"].string ?? "解析失败"
        totalthumbup = String(jsonData["totalthumbup"].int ?? 0)
        totalcomments = String(jsonData["totalcomments"].int ?? 0)
    }
    
}
