//
//  UserAccount.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/1.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON
/*
 1. 遵守 NSCoding 协议
 2. 实现两个方法
 
 
 */
class UserAccount: NSObject, NSCoding{
    
    var access_token: String?
    var expires_time: TimeInterval = 0 {
        didSet {
            expires_date = NSDate(timeIntervalSince1970: expires_time)
        }
    }
    var uid: String?
    
    // 过期的日期
    var expires_date: NSDate?
    
    // 用户昵称
    var nickname: String?
    
    // 用户头像
    var avatar_large: String?
    
    
    init(jsonData: JSON) {
        super.init()
        self.access_token = jsonData["access_token"].string
        self.uid = jsonData["uid"].string
    }
    
    // MARK: - 保存当前对象`键值`归档
    func saveUserAccount () {
        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        accountPath += "/userAccount.plist"

        NSKeyedArchiver.archiveRootObject(self, toFile: accountPath)    
    }

    //MARK: 实现NSCoding 协议方法
    // 解归档：将磁盘中的二进制数据转换成自定义对象，与反序列化很像
    // 'required' - 没有继承性，所有的对象只能解档出当前的类对象。
    
    required init?(coder: NSCoder) {

        super.init()

        access_token = coder.decodeObject(forKey: "access_token") as? String
        expires_date = coder.decodeObject(forKey: "expires_date") as? NSDate
        uid = coder.decodeObject(forKey: "uid") as? String
        avatar_large = coder.decodeObject(forKey: "avatar_large") as? String
        nickname = coder.decodeObject(forKey: "nickname") as? String
    }

    // 归档：将对象转换二进制保存到磁盘中，序列化
    func encode(with coder: NSCoder) {
        coder.encode(access_token, forKey: "access_token")
        coder.encode(expires_date, forKey: "expires_date")
        coder.encode(uid, forKey: "uid")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(avatar_large, forKey: "avatar_large")
    }
}

// 在 extensiton 中只允许写便利构造函数，而不能写指定的构造函数，不能定义存储型属性
// 定义存储型属性，会破坏本身的结构

extension UserAccount {
    
}
