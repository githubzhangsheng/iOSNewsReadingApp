//
//  UIColor+Extension.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/19.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

/// UIColor的扩展
extension UIColor {
    
    static func hex(_ string: String, alpha: CGFloat = 1.0) -> UIColor {
        let scanner = Scanner(string: string)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0x00ff00) >> 8
        let b = (rgbValue & 0x0000ff)
        if #available(iOS 10.0, *) {
            return UIColor(
                displayP3Red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: alpha
            )
        } else {
            return UIColor(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: alpha
            )
        }
    }
}
