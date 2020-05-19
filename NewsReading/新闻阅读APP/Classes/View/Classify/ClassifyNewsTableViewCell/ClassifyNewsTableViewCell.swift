//
//  ClassifyNewsTableViewCell.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/5.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ClassifyNewsTableViewCell: UITableViewCell {
    /// 新闻视图模型
    var viewModel: NewsViewModel? {
        didSet {
            titleLabel.text = self.viewModel?.newsObject.title
            bottomView.viewModel = self.viewModel
        }
    }
    
    // MARK: - 懒加载控件
    /// 标题
    private lazy var titleLabel: UILabel = UILabel(title: "大标题", fontSize: 16, color:UIColor.black, screenInset: NewsCellMargin)
    /// 底部视图
    private lazy var bottomView: ClassifyBottomView = ClassifyBottomView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置界面
extension ClassifyNewsTableViewCell {
    private func setupUI() {
        // 1. 添加控件
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomView)
        // 2. 自动布局
        // 1) 顶部视图
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top)
            make.left.equalTo(contentView.snp_left).offset(NewsCellMargin)
            make.width.equalTo(contentView.snp_width).offset(-NewsCellMargin*2)
        }
        // 2) 底部视图
        bottomView.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(NewsCellMargin)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp_bottom)
        }
    }
}
