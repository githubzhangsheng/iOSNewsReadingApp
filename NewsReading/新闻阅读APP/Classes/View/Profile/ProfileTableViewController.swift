//
//  ProfileTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class ProfileTableViewController: VisitorTableViewController {
    var webView: WKWebView!
    func initWebView () {
        self.tableView.separatorStyle = .none
        let mainSize = UIScreen.main.bounds.size
        let jsStr = "function logout() {var title = document.getElementById('title'); title.innerText='请登录后再试！'}"
        let script: WKUserScript = WKUserScript(source: jsStr, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.addUserScript(script)
        
        // 设置 webview 代理
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: mainSize.width, height: mainSize.height), configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.userContentController.add(self, name: "logout")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedUserAccount.userLogin {
            visitorLoginView?.setUIInfo(imageName: "visitordiscover_image_profile", title: "登录后，查看个人信息")
            return
        }
        initWebView()
        view.addSubview(webView)
        
        // 加载本地网页
        loadLocalWebPage()
        
        // 加载测试页面
//        loadWebURL()

    }
    // 视图将要显示时调用该方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    /// swift调JS
    /// - Parameters:
    ///   - message: "jsReceiveImage(\"图片base64\")"
    ///   - success: 成功的回调函数
    ///   - fail: 失败的回调函数
    func swiftCallJS(message:String, success:(()->())?, fail:(()->())?) {
        if !self.webView.isLoading {

            self.webView.evaluateJavaScript(message, completionHandler: { (response, error) in
                if !(error != nil){
                    if success != nil {
                        success!()
                    }
                }else{
                    if fail != nil {
                        fail!()
                    }
                }
            })
        }
    }
    func loadLocalWebPage() {
        let path:String = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "PersonalPage")!
        let url = URL.init(fileURLWithPath: path)
        let urlRequest = URLRequest.init(url: url)
        webView.load(urlRequest)
    }
    func loadWebURL() {
        let testURL = URL(string: "http://127.0.0.1:1024/")
        let testRequest = URLRequest(url: testURL!)
        webView.load(testRequest)
    }
    func logout() {
        UserAccountViewModel.sharedUserAccount.logout()
        self.webView.removeFromSuperview()
        self.loadVisitorView()
        visitorLoginView?.setUIInfo(imageName: "visitordiscover_image_profile", title: "登录后，查看个人信息")
    }
}

// MARK: WKUIDelegate
extension ProfileTableViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("界面弹出了警告框")
        print("警告框的内容：\(message)")
        completionHandler()
    }
}
// MARK: WKNavigationDelegate
extension ProfileTableViewController: WKNavigationDelegate {
//    // 页面开始加载时调用
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("页面开始加载时调用")
//    }

//    // 页面内容开始返回调用
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        print("页面内容开始返回调用")
//    }

    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载完成之后调用")
        let imageData = UserAccountViewModel.sharedUserAccount.account?.avatar_large ?? "#"
        let nickname = UserAccountViewModel.sharedUserAccount.account?.nickname ?? "无名烈士"

        let message:String = "setData('\(imageData)','\(nickname)')"

        self.swiftCallJS(message: message, success: {
            print("swiftCallJS 调用成功")
        }) {
            print("swiftCallJS 调用失败！")
        }
    }

    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败时调用")
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print("在发送请求之前，决定是否跳转")
        decisionHandler(.allow)
    }

    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print("在收到响应后，决定是否跳转")
        decisionHandler(.allow)
    }

    // 接收到服务器跳转请求之后执行
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        print("接收到服务器跳转请求之后执行")
    }

}

// 实现消息传递的代理
extension ProfileTableViewController: WKScriptMessageHandler {
    // JS调用原生方法的处理
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("JS 调用了\(message.name)方法，传回参数\(message.body)")
        if message.name == "testJS" {
//            let data: Dictionary = message.body as! Dictionary<String, Any>
//            testJS(name:data["name"] as! String, pass:data["pass"] as! String)
        } else if message.name == "logout" {
            logout()
        }
        
    }
}
