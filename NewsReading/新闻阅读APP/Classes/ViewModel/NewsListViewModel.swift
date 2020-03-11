//
//  NewsListViewModel.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import SwiftyJSON

// 新闻数据列表模型 - 封装网络方法
class NewsListViewModel {
    
    /// 新闻数据数组 - 上拉/下拉刷新
    lazy var newsList = [NewsViewModel]()
    
    /// 加载网络数据
    func loadNews(type:String,finished:@escaping (Bool)->()) {
        NetworkTools.sharedTools.loadStatus(type: type) { (result, error) in
            if error != nil {
                print("出错了")
                finished(false)
                return
            }
            
            let array = JSON(result!)["data"].array
            // 1. 初始化可变数组
            var dataList = [NewsViewModel]()
            
            // 2. 遍历数组
            for jsonData in array! {
                dataList.append(NewsViewModel(newsObject: NewsObject(jsonData: jsonData)))
            }
            
            // 3. 拼接数据
//            self.newsList = dataList + self.newsList
            self.newsList = dataList
            // 4. 完成回调
            finished(true)
        }
    }
    
}
