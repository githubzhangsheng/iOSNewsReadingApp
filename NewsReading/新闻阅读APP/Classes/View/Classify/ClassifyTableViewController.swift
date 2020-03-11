//
//  MessageTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ClassifyTableViewController: UITableViewController {
    private var pageTitleView: SGPageTitleView? = nil
    private var pageContentScrollView: SGPageContentScrollView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        view.backgroundColor = UIColor.white
        // 添加 SGPagingView
        setupSGPagingView()
    }


}

// MARK: - - 设置 SGPagingView
extension ClassifyTableViewController {
    private func setupSGPagingView() {
        let pageTitleViewY: CGFloat = 0.0
        
        let titles = ["科技", "体育", "财经", "游戏"]
        let configure = SGPageTitleViewConfigure()
        configure.showIndicator = false
        configure.showBottomSeparator = false
        configure.titleColor = UIColor.gray
        configure.titleSelectedColor = UIColor.black
        configure.titleGradientEffect = true
        
        self.pageTitleView = SGPageTitleView(frame: CGRect(x: 0, y: pageTitleViewY, width: view.frame.size.width, height: 44), delegate: self, titleNames: titles, configure: configure)
        pageTitleView?.index = 0
        view.addSubview(pageTitleView!)
        
        let oneVC = NewsTableViewController(name: "科技")
        let twoVC = NewsTableViewController(name: "体育")
        let threeVC = NewsTableViewController(name: "财经")
        let fourVC = NewsTableViewController(name: "游戏")
        let childVCs = [oneVC, twoVC, threeVC, fourVC]
        
        let contentViewHeight = view.frame.size.height - self.pageTitleView!.frame.maxY - 100
        let contentRect = CGRect(x: 0, y: (pageTitleView?.frame.maxY)!, width: view.frame.size.width, height: contentViewHeight)
        self.pageContentScrollView = SGPageContentScrollView(frame: contentRect, parentVC: self, childVCs: childVCs)
        pageContentScrollView?.delegateScrollView = self
        view.addSubview(pageContentScrollView!)
    }
}
// MARK: - - 设置 SGPagingView 代理方法
extension ClassifyTableViewController: SGPageTitleViewDelegate, SGPageContentScrollViewDelegate {
    func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
        pageContentScrollView?.setPageContentScrollView(index: index)
    }
    
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        pageTitleView?.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
