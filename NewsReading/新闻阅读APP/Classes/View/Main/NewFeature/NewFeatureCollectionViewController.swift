//
//  NewFeatureCollectionViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019 mac. All rights reserved. 
//

import UIKit
import SnapKit

// 可重用 CellID f
private let NewsNewFeatureViewCellId = "Cell"
// 新特性图片的数量
private let NewsNewFeatureImageCount = 4
class NewFeatureCollectionViewController: UICollectionViewController {
    
    // MARK: - 构造函数
    init() {
        // super.指定的构造函数
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 构造函数，完成之后内部属性才会被创建
        super.init(collectionViewLayout: layout)
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false // 关闭弹簧效果
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var prefersStatusBarHidden: Bool {
           return true
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册可重用cell
        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: NewsNewFeatureViewCellId)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    // 每个分组中，格子的数量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return NewsNewFeatureImageCount
    }

    // Cell 方法
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsNewFeatureViewCellId, for: indexPath) as! NewFeatureCell
    
        // Configure the cell
        cell.imageIndex = indexPath.item
    
        return cell
    }
    // ScrollView 停止滚动的方法
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 在最后一页才调动动画方法
        // 根据 contentOffeset 计算页数
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        // 判断是否是最后一页
        if page != NewsNewFeatureImageCount - 1 {
            return
        }
        
        // cell 播放动画
        let cell = collectionView?.cellForItem(at: NSIndexPath(item: page, section: 0) as IndexPath) as! NewFeatureCell
        
        cell.showButtonAnim()
        
        
        
    }
}

// MARK: - 新特性cell
private class NewFeatureCell: UICollectionViewCell {
    // 图像属性
    var imageIndex:Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            
            // 隐藏按钮
            startButton.isHidden = true
        }
    }
    // 点击开始体验按钮
    @objc func clickStartButton() {
        NotificationCenter.default.post(name: NSNotification.Name(NewsSwitchRootViewControllerNotification), object: nil)
    }
    // 显示按钮动画
    func showButtonAnim() {
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0,y: 0)
        startButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            self.startButton.transform = CGAffineTransform.identity
        }) { (_) in
            self.startButton.isUserInteractionEnabled = true
        }
        
    }
    // frame 的大小是 layout.itemSize 指定的
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 1. 添加控件
        addSubview(iconView)
        addSubview(startButton)
        
        // 2. 指定位置
        iconView.frame = bounds
        iconView.backgroundColor = UIColor.yellow
        startButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.bottom.equalTo(self.snp_bottom).multipliedBy(0.8)
        }
        
        // 3. 监听方法
        startButton.addTarget(self, action: Selector(("clickStartButton")), for: .touchUpInside)
    }
    
    // MARK: - 懒加载控件
    private lazy var iconView: UIImageView = UIImageView()
    private lazy var startButton: UIButton = UIButton(title: "开始体验", color: UIColor.white, backImageName: "new_feature_finish_button")
}
