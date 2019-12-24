//
//  UserAccountViewModel.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import SwiftyJSON
/// 用户账号视图模型 - 没有父类
/*
    模型通常继承自 NSObject -> 可以使用 KVC 设置属性，简化对象构造
    如果没有父类，所有的内容都需要从头创建，量级更轻
 
    视图模型的作用，封装业务逻辑，通常没有复杂的属性
 
    
 
 */
class UserAccountViewModel {
    // 单例 - 避免重复从沙盒加载、归档、文件，提高效率，避免被重复访问到。
    static let sharedUserAccount = UserAccountViewModel()
    // 用户模型
    var account: UserAccount?
    // 用户登录标记
    var userLogin: Bool {
        // 1. 如果token有值，说明登录成功
        // 2. 如果没有过期，说明登录有效
        return account?.access_token != nil && !isExpired
    }
    // 用户头像 URL
    var avatarURL: URL {
        return URL(string: account?.avatar_large ?? "")!
    }
    private var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return accountPath + "/userAccount.plist"
    }
    // 判断账户是否过期
    private var isExpired: Bool {
        // 判断用户账户过期日期与当前系统日期进行比较
        if account?.expires_date?.compare(Date()) == ComparisonResult.orderedDescending {
            return false
        }
        // 过期了返回 true
        return true
    }
    /// 构造函数 - 私有化，会要求外部只能通过单例常量访问，而不能()实例化
    private init() {
        // 从沙盒解档数据,恢复当前数据，从磁盘中读写
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        
        // 判断token是否过期
        if isExpired {
            print("已经过期")
            // 如果过期，清空解档的数据
            account = nil
        }
    }
}

extension UserAccountViewModel {
    // 0 登录成功，1 网络/服务器错误，2 账号密码错误，3 登录成功，账号密码输入错误
    func userSignIn(username: String, password: String, finished:@escaping (Int)->()) {
        NetworkTools.sharedTools.userSignIn(username: username, password: password) {
            result, error in
            
            if error != nil {
                print("登录失败，网络错误")
                finished(1)
                return;
            }
            
            let jsonData = JSON(result!)
            let code = jsonData["code"].int
            print(jsonData)
            if code == 0 {
                print("登录成功")
                self.account = UserAccount(jsonData: jsonData)
                self.account!.expires_time = jsonData["expires_time"].double!
                self.loadUserInfo(account: self.account!, finished: finished )
                
            } else {
                print("登录失败，账号密码有误")
                finished(2)
            }
        }
    }
    
    // 获取用户信息
    private func loadUserInfo(account: UserAccount,finished:@escaping (Int)->()) {
        NetworkTools.sharedTools.loadUserInfo(uid: account.uid!, accessToken: account.access_token!) { (result, error) in
            if error != nil {
                print("加载用户信息出错了")
                finished(3)
                return
            }
            
            let resJsonData = JSON(result!)
            account.avatar_large = resJsonData["avatar_large"].string
            account.nickname = resJsonData["nickname"].string
            account.saveUserAccount()
            finished(0)
        }
    }
}
