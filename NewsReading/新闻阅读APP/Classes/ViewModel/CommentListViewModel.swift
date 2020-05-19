//
//  CommentListViewModel.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/23.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentListViewModel {
    /// 评论数据数组 - 上拉/下拉刷新
    lazy var commentList = [CommentViewModel]()
    
    /// 加载网络数据
    func loadComments(newsid:String,finished:@escaping (Bool)->()) {
        NetworkTools.sharedTools.loadComments(newsid: newsid) { (result, error) in
            // 网络出现错误
            if error != nil {
                finished(false)
                return
            }
            let array = JSON(result!)["data"].array
            // 1. 初始化可变数组
            var dataList = [CommentViewModel]()

            // 2. 遍历数组
            for jsonData in array! {
                dataList.append(CommentViewModel(commentObject: CommentObject(jsonData: jsonData)))
            }

            self.commentList = dataList
            // 3. 完成回调
            finished(true)
            
        }

    }
}


