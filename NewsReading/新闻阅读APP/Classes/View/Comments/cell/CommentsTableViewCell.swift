//
//  CommentsTableViewCell.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/23.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    /// 评论视图模型
    var viewModel: CommentViewModel? {
        didSet {
            topView.viewModel = self.viewModel
            contentLabel.text = self.viewModel?.commentObject.content
        }
    }
    /// 顶部视图
    private lazy var topView: CommentsCellTopView = CommentsCellTopView()
    /// 评论
    private lazy var contentLabel: UILabel = UILabel(title: "评论正文", fontSize: 14, color: UIColor.darkGray, screenInset: NewsCellMargin)
    /// 底部视图
    private lazy var bottomView: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - 设置界面
extension CommentsTableViewCell {
    
    private func setupUI() {
        // 1. 添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        
        // 2. 自动布局
        // 1） 顶部视图
        topView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            // TODO: - 修改高度
            make.height.equalTo(2 * NewsCellMargin + commentsAvatarWidth)
        }
        // 2) 内容标签
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(topView.snp_bottom)
            make.left.equalTo(self.snp_left).offset(NewsCellMargin)
        }
        // 3) 底部视图
        bottomView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(NewsCellMargin)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(1)
            make.bottom.equalTo(contentView.snp_bottom)
        }
        
    }
}
