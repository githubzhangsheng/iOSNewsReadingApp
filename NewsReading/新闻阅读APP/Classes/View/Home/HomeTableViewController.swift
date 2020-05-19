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

// 新闻cell的可重用标识符号
let NewsObjectCellNormalId = "NewsObjectCellNormalId"

class HomeTableViewController: UITableViewController {
    
    // 新闻数据列表模型
    private lazy var listViewModel = NewsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        loadData()
    }
    // 准备表格
    private func prepareTableView() {
        // 注册可重用 cell
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: NewsObjectCellNormalId)
        

        // 自动计算行高 - 需要一个自上而下的自动布局的控件，指定一个向下的约束，需要在 NewsCell 的自动布局中设置
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.lightGray
        
        // 下拉刷新（默认没有）
        self.refreshControl = NewsRefreshController()
        
        // 添加监听方法
        self.refreshControl?.addTarget(self, action:#selector(loadData), for: .valueChanged)

        // 设置 tintColor ，即设置小菊花的前景色
        self.refreshControl?.tintColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushCommentsList), name: NSNotification.Name(rawValue: "aaa"), object: nil)
        
    }
    // MARK: 查看评论列表
    @objc func pushCommentsList(obj:Notification){
        let id:String! = obj.object as? String
        let commentsPage = CommentsTableViewController(newsid: id)
        self.navigationController?.pushViewController(commentsPage, animated: true)
        
    }
    // 加载数据
    @objc private func loadData() {
        
        refreshControl?.beginRefreshing()
        
        listViewModel.loadNews(type:"hot") { (isSuccessed) in
            self.refreshControl?.endRefreshing()
            
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            
            self.tableView.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: 数据源方法
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsObjectCellNormalId, for: indexPath) as! NewsCell
        
        cell.viewModel = listViewModel.newsList[indexPath.row]
        
        return cell
    }
    
    override func viewDidLayoutSubviews(){
     super.viewDidLayoutSubviews()
        refreshControl?.superview?.sendSubviewToBack(refreshControl!)
    }
    
}

