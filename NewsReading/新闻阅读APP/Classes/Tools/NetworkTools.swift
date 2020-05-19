//
//  NetworkTools.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/22.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AFNetworking

// 请求方法枚举
enum RequestMethod: String {
    case get = "get"
    case post = "post"
}
typealias RequestCallBack = (Any?, Error?)->()
// MARK: 网络工具
class NetworkTools: AFHTTPSessionManager {
    // 单例
//    static let sharedTools: NetworkTools = {
//        let baseURL = URL(string: "http://127.0.0.1:3001/")
//        let tools = NetworkTools(baseURL: baseURL)
//        return tools
//    }()
    
    // 本地测试服
    let baseURLString:String = "http://127.0.0.1:3001/"
    
    // 网易新闻api
    let NetEaseBaseURL:String = "https://3g.163.com/touch/reconstruct/article/list/"
    
    static let sharedTools: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json","text/json","text/javascript","text/plain") as? Set<String>
        tools.responseSerializer = AFHTTPResponseSerializer()
        return tools
    }()
    
    var accessToken:String?
}
/// MARK: - 封装 网易新闻相关的方法
extension NetworkTools {
    func loadNetEaseNewsList (type:String, number:String, finished: @escaping RequestCallBack) {
        let numberString:String = "/0-\(number).html"
        let urlString:String = self.NetEaseBaseURL + type + numberString
        self.request(method: .get, URLString: urlString, parameters: nil, finished:finished)
    }
    func loadNetEaseNewsDetail (id:String, finished: @escaping RequestCallBack) {
        let urlString:String = "https://api.xiaohuwei.cn/memeda.php"
        let params = ["id":id]
        self.request(method: .get, URLString: urlString, parameters: params, finished: finished)
    }
}
/// MARK: - 封装 用户相关的方法
extension NetworkTools {
    
    /// 加载用户信息
    /// - Parameters:
    ///   - uid: uid
    ///   - accessToken: token
    ///   - finished: 完成回调
    func loadUserInfo(uid: String, accessToken: String, finished: @escaping RequestCallBack) {
        let urlString = baseURLString + "api/user/getUserInfo"
        let params = ["uid":uid]
        self.requestSerializer.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        
        self.request(method: .get, URLString: urlString, parameters: params, finished:finished)
    }
    
    /// 用户登录并获取token
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 用户密码
    ///   - finished: 完成回调
    func userSignIn(username: String, password: String, finished:@escaping RequestCallBack) {
        let urlString = baseURLString + "api/user/signIn"
        let params = ["username": username, "password": password]
        self.request(method: .post, URLString: urlString, parameters: params, finished: finished)
    }
    /// 注册用户
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 用户密码
    ///   - finished: 完成回调
    func register(username:String, password: String, nickname:String,finished:@escaping RequestCallBack) {
        let urlString = baseURLString + "api/user/register"
        let params = ["username": username, "password": password,"nickname":nickname,"avatar":"default.jpg"]
        self.request(method: .post, URLString: urlString, parameters: params, finished: finished)
    }
}
// MARK: - 新闻数据相关方法
extension NetworkTools {
    func loadStatus(type:String, finished: @escaping RequestCallBack) {
        // 1. 准备参数
        let params = ["type":type]
        
        // 2. 准备网络接口
        let urlString = baseURLString + "api/news"
        
        // 3. 发起网络请求
        self.request(method: .get, URLString: urlString, parameters: params, finished: finished)
    }
    func thumbup(uid: String, newsid: String,finished: @escaping RequestCallBack) {
        let token:String = UserAccountViewModel.sharedUserAccount.account?.access_token ?? "0"
        self.requestSerializer.setValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        let params = ["uid":uid,"newsid":newsid]
        let urlString = baseURLString + "api/news/thumbup"
        self.request(method: .get, URLString: urlString, parameters: params, finished: finished)
    }
}
// MARK: - 评论数据相关方法
extension NetworkTools {
    func loadComments(newsid:String, finished: @escaping RequestCallBack) {
        // 1. 准备参数
        let params = ["newsid":newsid]
        
        // 2. 准备网络接口
        let urlString = baseURLString + "api/comments/get"
        
        // 3. 发起网络请求
        self.request(method: .get, URLString: urlString, parameters: params, finished: finished)
    }
    func sendComment(newsid:String, uid:String, content:String, parentid:String, finished: @escaping RequestCallBack) {
        let token:String = UserAccountViewModel.sharedUserAccount.account?.access_token ?? "0"
        self.requestSerializer.setValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        // 1. 准备参数
        let params = ["newsid":newsid, "uid":uid, "content":content, "parentid":parentid]
        
        // 2. 准备网络接口
        let urlString = baseURLString + "api/comments/post"
        
        // 3. 发起网络请求
        self.request(method: .post, URLString: urlString, parameters: params, finished: finished)
    }
}

// MARK: - 封装 AFN 网络方法
extension NetworkTools {
    /// 网络请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter finished:   完成回调
    func request(method:RequestMethod ,URLString: String, parameters:[String: Any]?,finished: @escaping (Any?,Error?)->()) {
        
        // 定义成功回调
        let success = { (task: URLSessionDataTask, result: Any?) in
            finished(result, nil)
        }
        // 定义失败回调
        let failure = { (task: URLSessionDataTask?, error:Error) in
            print(error)
            finished(nil, error)
        }

        
        if method == RequestMethod.get {
            self.get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            self.post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        

    }
}
