//
//  NewsRefreshController.swift
//  新闻阅读APP
//
//  Created by mac on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

private let NewsRefreshControlOffset:CGFloat = -70

/// 自定义刷新控件 - 负责处理刷新逻辑
class NewsRefreshController: UIRefreshControl {
    
    // MARK: - 重写系统方法
    override func endRefreshing() {
        super.endRefreshing()
        
        refreshView.stopAnimation()
    }
    
    // 主动触发开始刷新动画 - 不会触发监听方法
    override func beginRefreshing() {
        super.beginRefreshing()
        
        refreshView.startAnimation()
    }
    // MARK: - KVO 监听方法
    /*
      1. 始终待在屏幕上
      2. 下拉的时候，frame 的 y 值一直变小，往上的时候一直变大
      3. 默认的 y 值是0
      4.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        // 判断是否正在刷新
        if isRefreshing {
            refreshView.startAnimation()
            return
        }
        if frame.origin.y < NewsRefreshControlOffset && !refreshView.rotateFlag {
            print("翻过来")
            refreshView.rotateFlag = true
        } else if frame.origin.y >= NewsRefreshControlOffset && refreshView.rotateFlag {
            print("转过去")
            refreshView.rotateFlag = false
        }
        
    }
    
    // MARK： - 构造函数
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 添加控件
        addSubview(refreshView)
        // 自动布局 - 从 XIB 加载的控件需要指定大小约束
        refreshView.snp_makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
            make.size.equalTo(refreshView.bounds.size)
        }
        // 使用 KVO 监听位置变化 - 主队列，当主线程有任务，就不调度队列中的任务执行。
        DispatchQueue.main.async {
           self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
        
    }
    // 删除 kvo 监听方法
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    // MARK: - 懒加载控件
    private lazy var refreshView = NewsRefreshView.refreshView()

}

/// 刷新视图 - 负责处理动画显示
class NewsRefreshView: UIView {
    
    var rotateFlag = false {
        didSet {
            rotateTipIcon()
        }
    }
    
    @IBOutlet weak var loadingIconView: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipiconView: UIImageView!
    
    // 从 XIB 加载视图
    class func refreshView() -> NewsRefreshView {
        let nib = UINib(nibName: "NewsRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options:nil)[0] as! NewsRefreshView
    }
    
    // 旋转图标动画
    // 顺时针和就近原则
    func rotateTipIcon() {
        var angle = CGFloat(Double.pi)
        angle += rotateFlag ? -0.0001 : 0.0001
        UIView.animate(withDuration: 0.5) {
            self.tipiconView.transform = self.tipiconView.transform.rotated(by: CGFloat(angle))
        }
    }
    
    // 播放加载动画
    func startAnimation() {
        tipView.isHidden = true
        
        // 判断动画是否被添加
        let key = "transform.rotation"
        if loadingIconView.layer.animation(forKey: key) != nil {
            return
        }
        
        let anim = CABasicAnimation(keyPath: key)
        
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        anim.isRemovedOnCompletion = false
        
        loadingIconView.layer.add(anim, forKey: key)
        
    }
    
    // 停止加载动画
    func stopAnimation() {
        tipView.isHidden = false
        loadingIconView.layer.removeAllAnimations()
        
    }
}
