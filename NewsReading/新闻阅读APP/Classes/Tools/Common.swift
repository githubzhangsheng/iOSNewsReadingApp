//
//  Common.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
// MARK: - 全局通知定义
let NewsSwitchRootViewControllerNotification = "NewsSwitchRootViewControllerNotification"

// MARK: - 全局外观渲染颜色
let themeColor = kRGBColorFromHex(rgbValue: 0xf17c67)

// MARK: - 全局函数，可以直接使用
/// 延迟在主线程执行函数
///
/// - parameter delta:    延迟时间
/// - parameter callFunc: 要执行的闭包
func delay(delta: Double, callFunc: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now()+delta, execute:
    {
        callFunc()
    })
}
func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
     return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
              green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
               blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
              alpha: 1.0)
 }
