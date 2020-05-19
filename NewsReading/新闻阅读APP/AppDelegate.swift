//
//  AppDelegate.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 设置主题色
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
        setThemeColor()
        
        // 监听通知
        // forName: 通知名称，通知中心用来识别通知的
        // object: 发送通知的对象，如果为nil，监听任何对象
        // queue: nil 为主线程
        // weak self,
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NewsSwitchRootViewControllerNotification), object: nil, queue: nil) { [weak self](notification) in
//            print(Thread.current)
//            print(notification)
            
            let vc = notification.object != nil ? WelcomeViewController() : MainViewController()
            // 监听到通知切换控制器
            self?.window?.rootViewController = vc
        }

        return true
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NewsSwitchRootViewControllerNotification), object: nil)
    }
    
    // 设置主题色
    private func setThemeColor() {
        UITabBar.appearance().tintColor = themeColor
    }


}
// MARK - 界面切换代码
extension AppDelegate {
    private var defaultRootViewController: UIViewController {
        // 1. 判断是否登录
        if UserAccountViewModel.sharedUserAccount.userLogin {
            return isNewVersion ? NewFeatureCollectionViewController() : WelcomeViewController()
        }
        // 2. 没有登录返回主控制器
        return MainViewController()
    }
    // 判断是否是新版本
    private var isNewVersion: Bool {
        // 1. 当前的版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        print("当前版本",version)
        
        // 2. 老的版本，把当前的版本保存在用户偏好里
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = UserDefaults.standard.double(forKey: sandboxVersionKey)
        print("之前的版本\(sandboxVersion)")
        
        // 3. 保存当前版本
        UserDefaults.standard.set(version, forKey: sandboxVersionKey)
        return version > sandboxVersion
    }
}

