//
//  UIImage+Extension.swift
//  新闻阅读APP
//
//  Created by mac on 2020/2/8.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(newWidth:CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
