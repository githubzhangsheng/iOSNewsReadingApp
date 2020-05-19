//
//  NewsViewModel.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import SwiftyJSON
/// 新闻视图模型  - 处理单条新闻模型的业务逻辑
class NewsViewModel {
    /// 新闻的模型
    var newsObject: NewsObject

    /// 构造函数
    init(newsObject: NewsObject) {
        self.newsObject = newsObject
    }
    
    func getNewsID () -> String {
        return newsObject.id
    }
    func getTotalComments () -> String {
        return newsObject.totalcomments
    }
    func getTotalThumbup () -> String {
        return newsObject.totalthumbup
    }
    
}
extension NewsViewModel {
    func loadNewsContent (finished:@escaping (Bool)->()) {
        NetworkTools.sharedTools.loadNetEaseNewsDetail(id: self.newsObject.id) { (result, error) in
            if error != nil {
//                print("内容加载出错")
                finished(false)
                return
            }
            let resStr:String = String(data: result as! Data,encoding: String.Encoding.utf8)!
            
            if let jsonData = resStr.data(using: .utf8) {
                let dicObj = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String : Any]
                self.newsObject.content = dicObj["body"] as? String
                finished(true)
                return
            }
            finished(false)
            
        }
    }
}
 
