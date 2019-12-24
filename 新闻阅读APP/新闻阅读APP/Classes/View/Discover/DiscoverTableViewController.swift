//
//  DiscoverTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DiscoverTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorLoginView?.setUIInfo(imageName: "visitordiscover_image_message", title: "登录后，发现更多有趣的新闻")
    }

}
