//
//  NewsTableViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/5.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking
import MJRefresh

class NewsTableViewController: UITableViewController {
    // 新闻cell的可重用标识符号
    private var NewsID = "NEWSID"
    // 板块分类名称
    var classifyname:String?
    // 新闻数据列表模型
    private lazy var listViewModel = NewsListViewModel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(name:String) {
        super.init(style: .plain)
        self.NewsID = "NewsID" + name
        self.classifyname = name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        loadData()

    }
    // 加载数据
    @objc private func loadData() {
        
        let NetEaseDic: [String: String] =
            ["headline": "BBM54PGAwangning",
             "科技": "BA8D4A3Rwangning",
             "体育":"BA8E6OEOwangning",
             "游戏":"BAI6RHDKwangning",
             "财经":"BA8EE5GMwangning"]
        
        refreshControl?.beginRefreshing()

//  本地新闻数据加载
//        listViewModel.loadNews(type: classifyname ?? "all") { (isSuccessed) in
//            self.tableView.mj_header!.endRefreshing()
//
//            if !isSuccessed {
//                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
//                return
//            }
//
//            self.tableView.reloadData()
//        }
        SVProgressHUD.show()
        listViewModel.loadNetEaseNews(type: NetEaseDic[classifyname ?? "headline"]!, number: "20") { (isSuccessed) in
            SVProgressHUD.dismiss()
            self.tableView.mj_header!.endRefreshing()
            print(isSuccessed)
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            self.tableView.reloadData()
        }
    }
    // 准备表格
    private func prepareTableView() {
        let header = MJRefreshNormalHeader()
        // 注册可重用 cell
        self.tableView.register(ClassifyNewsTableViewCell.self, forCellReuseIdentifier: NewsID)
        
        tableView.rowHeight = 120
  
        header.setRefreshingTarget(self, refreshingAction: #selector(loadData))
        self.tableView.mj_header = header
        
        // 删除tableview多余的分割线
        let view = UIView()
        view.backgroundColor = UIColor.clear
        tableView.tableFooterView = view
        
    }


}
// MARK: 数据源方法
extension NewsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.newsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsID, for: indexPath) as! ClassifyNewsTableViewCell
        
        cell.viewModel = listViewModel.newsList[indexPath.row]
        
        return cell
    }
    // 取消单元格选中状态
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let newsVC = NewsDetailUIViewController()
        newsVC.viewModel = listViewModel.newsList[indexPath.row]
        self.navigationController!.pushViewController(newsVC, animated: true)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        refreshControl?.superview?.sendSubviewToBack(refreshControl!)
    }
    
}
