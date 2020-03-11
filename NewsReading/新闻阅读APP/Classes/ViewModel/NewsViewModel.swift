//
//  NewsViewModel.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

/// 新闻视图模型  - 处理单条新闻模型的业务逻辑
class NewsViewModel {
    /// 新闻的模型
    var newsObject: NewsObject
    
    /// 用户头像 URL
//    var userProfile: NSURL {
//        return NSURL(string: newsObject.user?.profile_image_url ?? "")
//    }
    
    /// 构造函数
    init(newsObject: NewsObject) {
        self.newsObject = newsObject
    }
    
    
}
 
