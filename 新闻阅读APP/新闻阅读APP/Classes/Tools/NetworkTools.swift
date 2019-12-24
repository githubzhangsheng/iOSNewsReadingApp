//
//  NetworkTools.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/22.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AFNetworking

// 网络请求案例
//        NetworkTools.sharedTools.request(method:RequestMethod.get, URLString: "http://httpbin.org/get", parameters: ["name":"wanglaowu"]) {
//            result, error in
//            if result != nil {
//                print(result!)
//            } else {
//                print("没有返回值")
//            }
//        }

// 请求方法枚举
enum RequestMethod: String {
    case get = "get"
    case post = "post"
}
typealias RequestCallBack = (Any?, Error?)->()
// MARK: 网络工具
class NetworkTools: AFHTTPSessionManager {
    // 单例
    static let sharedTools: NetworkTools = {
        let baseURL = URL(string: "http://129.204.150.231:3001")
        let tools = NetworkTools(baseURL: baseURL)
        return tools
    }()
}
// MARK: - 封装 用户相关的方法
extension NetworkTools {
    
    /// 加载用户信息
    /// - Parameters:
    ///   - uid: uid
    ///   - accessToken: token
    ///   - finished: 完成回调
    func loadUserInfo(uid: String, accessToken: String, finished: @escaping RequestCallBack) {
        let urlString = "/api/user/getUserInfo"
        let params = ["uid":uid, "access_token":accessToken]
        self.request(method: .get, URLString: urlString, parameters: params, finished:finished)
    }
    
    /// 用户登录并获取token
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 用户密码
    ///   - finished: 完成回调
    func userSignIn(username: String, password: String, finished:@escaping RequestCallBack) {
        let urlString = "/api/user/signIn"
        let params = ["username": username, "password": password]
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
