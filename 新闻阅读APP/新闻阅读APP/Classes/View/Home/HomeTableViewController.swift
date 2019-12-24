//
//  HomeTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class HomeTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorLoginView?.setUIInfo(imageName: nil, title: "登录后，查看更多精彩新闻")
    }

}
