//
//  BaseTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


// 在OC中没有多继承，协议中是必选的方法，如果不实现，会报错

class VisitorTableViewController: UITableViewController,VisitorLoginViewDelegate {
    
    // 添加用户是否登录的标记
    var userLogin = UserAccountViewModel.sharedUserAccount.userLogin
    var visitorLoginView: VisitorLoginView?
    
    // loadView 是专门为手写代码准备的，等效于 sb/xib
    // 一旦实现这个方法，xib / sb 就自动失效了
    // 会自动检测 view 是否为空，如果为空，会自动调用loadView方法
    
    override func loadView() {
        
        userLogin ? super.loadView() : loadVisitorView()
        
    }
    
    func loadVisitorView () {
        
        visitorLoginView = VisitorLoginView()
        
        // 设置visitorLoginView的代理
        visitorLoginView?.visitorDelegate = self
        
        view = visitorLoginView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(visitorWillRegister))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登陆", style: .plain, target: self, action: #selector(visitorWillLogin))
        
    }
    
    // 视图控制器
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
// MARK: - 访客视图监听方法
extension VisitorTableViewController {
    //MARK: visitorDelegate 协议方法
    @objc func visitorWillRegister() {
        print("准备注册")
        let registerPage = RegisterViewController()
        let nav = UINavigationController(rootViewController: registerPage)
        present(nav, animated: true, completion: nil)
    }
    @objc func visitorWillLogin() {
        print("准备登陆")
        
        let loginPage = LoginViewController()
        let nav = UINavigationController(rootViewController: loginPage)
        present(nav, animated: true, completion: nil)
        
    }
}
