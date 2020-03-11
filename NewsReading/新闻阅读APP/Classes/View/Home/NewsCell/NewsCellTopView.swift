//
//  NewsCellTopView.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
/// 新闻 cell 顶部视图
class NewsCellTopView: UIView {
    
    /// 新闻视图模型
    var viewModel: NewsViewModel? {
        didSet {
            // 设置顶部区域的一些信息，需要封装顶部model后调用
            // 包括昵称、头像
            // 小的头像，利用 UIImage(imagedName) 创建的图像，缓存由系统管理，程序员不能直接释放
            // 注意：高清大图不要使用这个方法 利用 contentOfFile
            nameLabel.text = self.viewModel?.newsObject.title
            // 时间
            timeLabel.text = self.viewModel?.newsObject.publish_time
            sourceLabel.text = self.viewModel?.newsObject.source
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    // 头像
    private lazy var iconView:UIImageView = UIImageView(imageName: "avatar_default_big")
    // 姓名
    private lazy var nameLabel: UILabel = UILabel(title: "王老五", fontSize: 14)
    // 会员图标
    private lazy var memberIconView: UIImageView = UIImageView(imageName: "common_icon_membership")
    // 认证图标
    private lazy var vipIconView: UIImageView = UIImageView(imageName: "avatar_vip")
    // 时间标签
    private lazy var timeLabel: UILabel = UILabel(title: "现在", fontSize: 11, color: UIColor.orange)
    // 来源标签
    private lazy var sourceLabel: UILabel = UILabel(title: "来源", fontSize: 11)
    
}

// MARK: - 设置界面
extension NewsCellTopView {
    private func setupUI() {
        
        // 0. 添加分隔视图
        let sepView = UIView()
        sepView.backgroundColor = UIColor.lightGray
        addSubview(sepView)
        
        
        // 1. 添加控件
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(memberIconView)
        addSubview(vipIconView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 2. 自动布局
        
        sepView.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(NewsCellMargin)
        }
        
        iconView.snp_makeConstraints { (make) in
            make.top.equalTo(sepView.snp_bottom).offset(NewsCellMargin)
            make.left.equalTo(self.snp_left).offset(NewsCellMargin)
            make.width.equalTo(NewsCellIconWidth)
            make.height.equalTo(NewsCellIconWidth)
        }
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_top)
            make.left.equalTo(iconView.snp_right).offset(NewsCellMargin)
        }
        memberIconView.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_top)
            make.left.equalTo(nameLabel.snp_right).offset(NewsCellMargin)
        }
        vipIconView.snp_makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp_right)
            make.centerY.equalTo(iconView.snp_bottom)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp_bottom)
            make.left.equalTo(iconView.snp_right).offset(NewsCellMargin)
        }
        sourceLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(timeLabel.snp_bottom)
            make.left.equalTo(timeLabel.snp_right).offset(NewsCellMargin)
        }
    }
}
