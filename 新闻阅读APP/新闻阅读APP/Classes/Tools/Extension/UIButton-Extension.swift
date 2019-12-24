//
//  UIButton-Extension.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIButton {
    
    // 遍历构造函数
    convenience init(imageName: String, backImageName:String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: UIControl.State.normal)
        setImage(UIImage(named: imageName+"_highlighted"), for: UIControl.State.highlighted)
        
        // 设置按钮背景颜色
        setBackgroundImage(UIImage(named: backImageName), for: UIControl.State.normal)
        setBackgroundImage(UIImage(named: backImageName+"_highlighted"), for: UIControl.State.highlighted)
        
        // 会根据背景图片的大小调整尺寸
        sizeToFit()
    }
    
    convenience init(title: String, color: UIColor, imageName: String) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named: imageName), for: .normal)
        sizeToFit()
    }
}
