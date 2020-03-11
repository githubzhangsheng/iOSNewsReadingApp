//
//  WelcomeViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    // 设置界面，视图的层次结构
    override func loadView() {
        // 直接使用背景图像作为根视图，不用关心图像缩放问题
        view = backImageView
        setupUI()
        
    }
    // 视图加载完成之后的后续处理，通常用来设置数据
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 异步加载用户头像
        iconView.sd_setImage(with: UserAccountViewModel.sharedUserAccount.avatarURL, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    // 视图已经显示，通常可以做动画/键盘处理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. 更改约束 -> 改变位置
        // snp_updateConstraints 更新已经设置过的约束
        // 使用自动布局开发，有一个原则，所有使用约束设置位置的控件，不要再设置frame
        // 原因：自动布局系统会根据设置的约束，自动计算控件的frame
        // 在 layoutSubViews 函数中设置frame
        // 如果程序员主动修改 frame 会引起自动布局系统计算错误
        iconView.snp_updateConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom).offset(-view.bounds.height + 200)
        }
        
        // 2. 动画
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            // 自动布局的动画
            self.view.layoutIfNeeded()
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.welcomeLabel.alpha = 1
            }) { (_) in
                // 发送通知
                NotificationCenter.default.post(name: NSNotification.Name(NewsSwitchRootViewControllerNotification), object: nil)
                
                
            }
            
        }
        
    }
    // MARK: - 懒加载控件
    private lazy var backImageView:UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(imageName: "avatar_default_big")
        // 设置圆角
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    // 欢迎标签
    private lazy var welcomeLabel: UILabel = UILabel(title: "欢迎回来", fontSize: 18)
}

// MARK: - 设置界面
extension WelcomeViewController {
    private func setupUI() {
        // 1. 添加控件
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        // 2. 自动布局
        iconView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_bottom).offset(-200)
            make.width.equalTo(90)
            make.height.equalTo(90)
            
        }
        
        welcomeLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp_bottom).offset(16)
        }
        
    }
}
