//
//  CommentsTopView.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/24.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SDWebImage

// 头像宽度
let commentsAvatarWidth:CGFloat = 35

class CommentsCellTopView: UIView {
    
    /// 新闻视图模型
    var viewModel: CommentViewModel? {
        didSet {
            nameLabel.text = self.viewModel?.commentObject.nickname
            timeLabel.text = self.viewModel?.commentObject.create_time
            // 异步加载用户头像
            iconView.sd_setImage(with: self.viewModel?.getAvatarURL(),placeholderImage: UIImage(named: "avatar_default_big"))
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
    private lazy var nameLabel: UILabel = UILabel(title: "王老五", fontSize: 13, color:themeColor)
    // 会员图标
    private lazy var memberIconView: UIImageView = UIImageView(imageName: "common_icon_membership")
    // 认证图标
//    private lazy var vipIconView: UIImageView = UIImageView(imageName: "avatar_vip")
    // 时间标签
    private lazy var timeLabel: UILabel = UILabel(title: "现在", fontSize: 11, color: UIColor.gray)
    

}

// MARK: - 设置界面
extension CommentsCellTopView {
    private func setupUI() {
        let margin:Int = 10
        
        // 1. 添加控件
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(memberIconView)
//        addSubview(vipIconView)
        addSubview(timeLabel)
        
        // 2. 自动布局
        iconView.layer.cornerRadius = 15
        iconView.layer.masksToBounds = true
        iconView.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(margin)
            make.left.equalTo(self.snp_left).offset(margin)
            make.width.equalTo(commentsAvatarWidth)
            make.height.equalTo(commentsAvatarWidth)
        }
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_top)
            make.left.equalTo(iconView.snp_right).offset(margin)
        }
        memberIconView.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_top)
            make.left.equalTo(nameLabel.snp_right).offset(margin)
        }
//        vipIconView.snp_makeConstraints { (make) in
//            make.centerX.equalTo(iconView.snp_right)
//            make.centerY.equalTo(iconView.snp_bottom)
//        }
        timeLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp_bottom)
            make.left.equalTo(iconView.snp_right).offset(margin)
        }
    }
}
