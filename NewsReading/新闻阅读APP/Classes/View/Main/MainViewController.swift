//
//  MainViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    // MARK: - 懒加载控件
    private lazy var composedButton: UIButton = UIButton(imageName: "tabbar_mic_btn", backgroundColor: UIColor.lightText, width: 30)
    
    // MARK: - 监听方法
    // 点击撰写按钮
    @objc private func clickComposedButton() {
        print("点我了")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 会创建tabBar中所有控制器对应的按钮
        super.viewWillAppear(animated)
        
        // 将 + 按钮带到最前面
        tabBar.bringSubviewToFront(composedButton)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加子视图控制器并不会创建 tabBar 中的按钮
        // 懒加载是无处不在的，所有的控件都是延迟创建的。
        // 所以会导致 composeButton 在原有的 tabbarChild 的按钮下面
        
        addChildViewControllers()
        
        setupComposeButton()
        
    }
    private func setupComposeButton() {
        // 1.添加按钮
        tabBar.addSubview(composedButton)
        
        
        // 2.调整按钮
        let count = children.count
        
        // 3. -1 是让按钮宽一点，能够解决手指点击的容错问题
        let w = tabBar.bounds.width / CGFloat(count) - 1
        
        composedButton.frame = tabBar.bounds.insetBy(dx: 2*w,dy: 0)
        
        // 4. 添加监听方法
        composedButton.addTarget(self, action:#selector(clickComposedButton), for: .touchUpInside)
        
        
    }
    
    private func addChildViewControllers() {
        addChild(vc: HomeTableViewController(), title: "首页热点", imageName: "tabbar_home")
        addChild(vc: ClassifyTableViewController(), title: "分类新闻", imageName: "tabbar_classify")
        
        addChild(UIViewController())
        
        addChild(vc: DiscoverTableViewController(), title: "发现更多", imageName: "tabbar_discover")
        addChild(vc: ProfileTableViewController(), title: "用户中心", imageName: "tabbar_profile")
    }
    
    private func addChild(vc: UIViewController, title: String, imageName: String) {
        // 实例化导航视图控制器
        let nav = UINavigationController(rootViewController: vc)
        
        // 设置tabbar点击的高亮颜色
//        tabBar.tintColor = UIColor.orange
        
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)?.resizeImage(newWidth: 30)
        
        // 添加
        addChild(nav)
    }
    

}
