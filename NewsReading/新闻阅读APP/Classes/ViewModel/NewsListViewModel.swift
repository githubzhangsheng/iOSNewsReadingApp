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
    
    func loadNetEaseNews(type:String, number:String, finished:@escaping (Bool)->()) {
        NetworkTools.sharedTools.loadNetEaseNewsList(type: type, number: number) { (result, error) in
            if error != nil {
                print("请求出错")
                finished(false)
                return
            }
            var resString:String = String(data: result as! Data,encoding: String.Encoding.utf8)!
            resString = resString.replacingOccurrences(of: ":null", with: ":\"\"")
            let start = resString.index(resString.startIndex, offsetBy: 29)
            let end = resString.index(resString.endIndex, offsetBy: -2)
            let range = Range<String.Index>(uncheckedBounds: (lower: start, upper: end))
            let resStr = String(resString[range])
            
            if let jsonData = resStr.data(using: .utf8) {
                let dicArr = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:AnyObject]]

                var dataList = [NewsViewModel]()
                for obj in dicArr {
                    dataList.append(NewsViewModel(newsObject: NewsObject(dict: obj)))
                }
                // 3. 拼接数据
                self.newsList = dataList
                
                // 4. 完成回调
                finished(true)
                return
            }
            finished(false)
            
        }
    }
    /// 加载网络数据
    func loadNews(type:String,finished:@escaping (Bool)->()) {
        NetworkTools.sharedTools.loadStatus(type: type) { (result, error) in
            if error != nil {
//                print("出错了")
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
