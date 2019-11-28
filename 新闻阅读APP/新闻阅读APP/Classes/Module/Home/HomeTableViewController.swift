//
//  HomeTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AFNetworking

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorLoginView?.setUIInfo(imageName: nil, title: "登录后，查看更多精彩新闻")
        
        // NSURLSession 主要的网络请求类
        // Reachability 判断网络的状态
        // Serialization 请求的序列化和反序列化
        
        let AFN = AFHTTPSessionManager()
        
        // 解决 failed: unacceptable content-type: text/html
        AFN.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        AFN.get("http://129.204.150.231", parameters: nil, progress: nil, success: { (task, result) in
            print(result ?? "没有结果")
        }) { (_, error) in
            print(error)
        }
    }

}
