//
//  User.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

// 用户模型
class User: NSObject {
    // 用户的UID
    var id: Int = 0
    // 用户昵称
    var nickname: String?
    // 用户头像地址
    var profile_image_url: String?
    // 认证类型
    var verified_type: Int = 0
    // 会员等级 0-6
    var mbrank: Int = 0
    
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["id", "nickname", "profile_image_url", "verified_type","mbrank"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
