//
//  CommentViewModel.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentViewModel {
    /// 新闻的模型
    var commentObject: CommentObject
    
    /// 构造函数
    init(commentObject: CommentObject) {
        self.commentObject = commentObject
    }
    func getAvatarURL() -> URL {
        return URL(string: self.commentObject.avatar ?? "")!
    }
}
