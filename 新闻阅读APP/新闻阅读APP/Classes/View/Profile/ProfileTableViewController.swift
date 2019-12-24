//
//  ProfileTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ProfileTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorLoginView?.setUIInfo(imageName: "visitordiscover_image_profile", title: "登录后，查看个人信息")
    }

}
