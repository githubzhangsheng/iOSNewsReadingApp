//
//  CommentsTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

let CommentsID = "CommentsID"

class CommentsTableViewController: UITableViewController {

    // 评论来自的新闻id
    var newsid:String?
    // 评论列表模型
    private lazy var listViewModel = CommentListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        loadData()
    }
    
    init(newsid:String) {
        super.init(style: .plain)
        self.newsid = String(newsid)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 监听方法-关闭窗口
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func readByVoice() {
        print("朗读评论")
    }
    
    // 准备表格
    private func prepareTableView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "朗读", style: .plain, target: self, action: #selector(readByVoice))
        self.navigationItem.title = "评论列表"
        
//        self.view.backgroundColor = UIColor.white

    
        // 注册可重用 cell
        self.tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsID)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.separatorInset = UIEdgeInsets.zero
//        self.tableView.
//        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
//        [_listTableView setLayoutMargins:UIEdgeInsetsZero];
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(loadData))
        header.setTitle("请下拉进行刷新", for: MJRefreshState.idle)
        header.setTitle("正在加载数据中...", for: MJRefreshState.refreshing)
        header.setTitle("没有更多数据了", for: MJRefreshState.noMoreData)
        header.setTitle("释放后开始刷新数据", for: MJRefreshState.willRefresh)
        
        self.tableView.mj_header = header
      
      // 删除tableview多余的分割线
        let view = UIView()
        view.backgroundColor = UIColor.clear
        tableView.tableFooterView = view
    }
    
    // 加载数据
    @objc private func loadData() {
        print("加载数据")
        refreshControl?.beginRefreshing()
        
        listViewModel.loadComments(newsid:self.newsid!) { (isSuccessed) in
            self.tableView.mj_header!.endRefreshing()
            
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            print("评论数据加载完毕")
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.commentList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsID, for: indexPath) as! CommentsTableViewCell
        
        cell.viewModel = listViewModel.commentList[indexPath.row]
        return cell
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        refreshControl?.superview?.sendSubviewToBack(refreshControl!)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
