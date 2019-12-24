//
//  UIImageView-Extension.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/22.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 便利构造函数
    ///
    /// - parameter imageName: imageName
    ///
    /// - returns: UIImageView
    convenience init(imageName: String) {
        self.init(image: UIImage(named: imageName))
    }
}
