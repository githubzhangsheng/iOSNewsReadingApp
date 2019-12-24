//
//  OAuthViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/29.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import AFNetworking

class OAuthViewController: UIViewController {
    
    
    
    // 定义一个webView属性
    let webView = WKWebView()
    
    //MARK: 监听方法
    @objc private func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func fullAccount() {
        let jsString = "document.getElementById('username').value = 'abc@123.com',document.getElementById('password').value = '123456'"
        
        // 在webView中执行js代码
        webView.evaluateJavaScript(jsString) { (_, error) in
        }
    }
    
    override func loadView() {
        view = webView
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化UI
        setupUI()
        
        // 加载网页
        loadOauthPage()
    }
    private func loadOauthPage(){
        let urlString = "http://129.204.150.231:3001/oauth"
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(fullAccount))
    }

}

// 专门处理 webView 所有的协议方法
extension OAuthViewController: WKUIDelegate,WKNavigationDelegate {
    //页面开始加载，可在这里给用户loading提示
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    //页面加载完成时
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    // 在请求开始加载之前调用，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url != nil {
            let urlString = navigationAction.request.url!.absoluteString
            if urlString.hasPrefix("http://www.amazingvue.cn") {
                
                guard let query = navigationAction.request.url?.query else {
                    // query没有数据
                    // 即账号密码错误，需要重试
                    return
                }
                
                let tokenString = query
                
                let startIndex = tokenString.index(tokenString.startIndex, offsetBy: 6)
                let endIndex = tokenString.endIndex
                let token = String(tokenString[startIndex..<endIndex])
                // 拿到token
                print(token)
                
                decisionHandler(WKNavigationActionPolicy.cancel)
            } else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }
            
        }

        
        
        
        
        
    }
}
