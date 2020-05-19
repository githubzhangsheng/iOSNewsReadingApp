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
    convenience init(imageName: String, backgroundColor:UIColor, width:CGFloat) {
        self.init()
        setImage(UIImage(named: imageName)?.resizeImage(newWidth: width), for: UIControl.State.normal)
        // 设置按钮背景颜色
        self.backgroundColor = backgroundColor
        // 会根据背景图片的大小调整尺寸
        sizeToFit()
    }
    
    
    convenience init(title: String, color: UIColor, backImageName: String) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        sizeToFit()
    }
    
    /// 便利构造函数
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字体大小
    ///   - color: 字体颜色
    ///   - imageName: 背景图像
    convenience init(title: String, fontSize:CGFloat, color: UIColor, imageName: String) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setImage(UIImage(named: imageName), for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        sizeToFit()
    }
    convenience init(title: String, fontSize:CGFloat, color: UIColor, bgColor: UIColor) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        backgroundColor = bgColor
    }
    convenience init(title: String, fontSize:CGFloat, color: UIColor, imageName: String, width: CGFloat) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        
        setImage(UIImage(named: imageName)?.resizeImage(newWidth: width), for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        sizeToFit()
    }
}
