//
//  NewsCell.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

/// 新闻 Cell 中控件的间距数值
let NewsCellMargin: CGFloat = 12
/// 新闻 Cell 头像的宽度
let NewsCellIconWidth: CGFloat = 35

class NewsCell: UITableViewCell {
    
    /// 新闻视图模型
    var viewModel: NewsViewModel? {
        didSet {
            topView.viewModel = self.viewModel
            bottomView.viewModel = self.viewModel
            contentLabel.text = self.viewModel?.newsObject.content
        }
    }
    
    // MARK: - 懒加载控件
    /// 顶部视图
    private lazy var topView: NewsCellTopView = NewsCellTopView()
    /// 新闻正文标签
    private lazy var contentLabel: UILabel = UILabel(title: "微博正文", fontSize: 15, color: UIColor.darkGray, screenInset: NewsCellMargin)
    /// 底部视图
    private lazy var bottomView: NewsCellBottomView = NewsCellBottomView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置界面
extension NewsCell {
    private func setupUI() {
        // 1. 添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        
        // 2. 自动布局
        // 1) 顶部视图
        topView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            // TODO: - 修改高度
            make.height.equalTo(2 * NewsCellMargin + NewsCellIconWidth)
        }
        // 2) 内容标签
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(topView.snp_bottom).offset(NewsCellMargin)
            make.left.equalTo(self.snp_left).offset(NewsCellMargin)
        }
        // 3) 底部视图
        bottomView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(NewsCellMargin)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp_bottom)
        }
    }
}
