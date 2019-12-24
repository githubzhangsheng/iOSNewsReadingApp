//
//  VisitorLoginView.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit



protocol VisitorLoginViewDelegate:NSObjectProtocol {
    
    // 协议方法
    
    // 登录
    func visitorWillLogin()
    
    // 注册
    func visitorWillRegister()
    
}

class VisitorLoginView: UIView {
    // 声明代理属性
    // 属性默认是强引用的，需要添加weak
    weak var visitorDelegate:VisitorLoginViewDelegate?
    
    @objc func loginBtnDidClick() {
        // 代理调用协议方法
        visitorDelegate?.visitorWillLogin()
        
    }
    @objc func registerBtnDidClick() {
         visitorDelegate?.visitorWillRegister()
    }
    
    
    //MARK: 设置页面信息
    func setUIInfo(imageName:String?, title:String) {
        circleView.isHidden = false
        tipLabel.text = title
        
        if imageName != nil {
            iconView.image = UIImage(named: imageName!)
            circleView.isHidden = true
        } else {
            // 让 circleView 动起来
            startAnimation()
        }
        
    }
    // 设置动画
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.repeatCount = MAXFLOAT
        // 转的角度
        anim.toValue = 2 * Double.pi
        anim.duration = 10
        // 当动画结束，或者视图处于非活跃状态，动画不移除图层
        anim.isRemovedOnCompletion = false
        circleView.layer.add(anim, forKey: nil)
    }
    // 重写构造方法
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 设置访客视图
    private func setupUI() {

        // 添加子控件
        addSubview(circleView)
        addSubview(discoverMaskView)
        addSubview(tipLabel)
        addSubview(iconView)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        
        // 设置frame布局失效
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 设置布局
        // VFL，布局的约束，尽量相对一个控件
        // 圆圈的约束
        addConstraint( NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint( NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -50))
        
        // 大头标的约束
        addConstraint( NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: circleView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint( NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: circleView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        // 提示文案的约束,constant 相对值
        
        addConstraint( NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: circleView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint( NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: circleView, attribute: .bottom, multiplier: 1.0, constant: 16))
        // 设置宽度约束
        addConstraint( NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 224))
        // 设置高度约束
        addConstraint( NSLayoutConstraint(item: tipLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
        
        
        // 设置登录按钮约束
        addConstraint( NSLayoutConstraint(item: loginBtn, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint( NSLayoutConstraint(item: loginBtn, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint( NSLayoutConstraint(item: loginBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint( NSLayoutConstraint(item: loginBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        
        // 设置注册按钮约束
        addConstraint( NSLayoutConstraint(item: registerBtn, attribute: .right, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint( NSLayoutConstraint(item: registerBtn, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint( NSLayoutConstraint(item: registerBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint( NSLayoutConstraint(item: registerBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        
       
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[discoverMaskView]-0-|", options: [], metrics: nil, views: ["discoverMaskView":discoverMaskView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[discoverMaskView]-(-70)-[registerBtn]", options: [], metrics: nil, views: ["discoverMaskView":discoverMaskView,"registerBtn":registerBtn]))
        
        // 设置背景颜色
        backgroundColor = UIColor(white: 0.93, alpha: 1)
        
        // 添加点击事件
        loginBtn.addTarget(self, action: #selector(loginBtnDidClick), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerBtnDidClick), for: .touchUpInside)
    }
    
    //MARK: 懒加载所有的控件
    private lazy var circleView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    private lazy var iconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    private lazy var discoverMaskView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    // 提示文案
    private lazy var tipLabel:UILabel = {
        let l = UILabel()
        l.text = "登录后，你可以随时看到你想要的新闻"
        l.textAlignment = NSTextAlignment.center
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor.lightGray
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    // 登录按钮
    private lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        return btn
    }()
    
    // 注册按钮
    private lazy var registerBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", for: .normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        btn.setTitleColor(themeColor, for: .normal)
        return btn
    }()
}
