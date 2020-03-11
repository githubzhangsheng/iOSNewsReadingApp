//
//  DiscoverTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class DiscoverTableViewController: VisitorTableViewController {

    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedUserAccount.userLogin {
            visitorLoginView?.setUIInfo(imageName: "visitordiscover_image_message", title: "登录后，搜索发现更多精彩新闻")
            return
        }
        initWebView()
        view.addSubview(webView)
    
    }
    func loadWebURL() {
        let testURL = URL(string: "http://127.0.0.1:1024/")
        let testRequest = URLRequest(url: testURL!)
        webView.load(testRequest)
    }
    func initWebView() {
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
        loadLocalWebPage()
//        loadWebURL()
    }
    func loadLocalWebPage() {
        let path:String = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "DiscoverPage")!
        let url = URL.init(fileURLWithPath: path)
        let urlRequest = URLRequest.init(url: url)
        webView.load(urlRequest)
    }

}
// MARK: WKNavigationDelegate
extension DiscoverTableViewController: WKNavigationDelegate {
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("页面开始加载时调用")
    }

    // 页面内容开始返回调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("页面内容开始返回调用")
    }

    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载完成之后调用")
    }

    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败时调用")
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("在发送请求之前，决定是否跳转")
        decisionHandler(.allow)
    }

    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("在收到响应后，决定是否跳转")
        decisionHandler(.allow)
    }

    // 接收到服务器跳转请求之后执行
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("接收到服务器跳转请求之后执行")
    }

}
extension DiscoverTableViewController:WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    
}
// MARK: WKUIDelegate
extension DiscoverTableViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("界面弹出了警告框")
        print("警告框的内容：\(message)")
        completionHandler()
    }
}
