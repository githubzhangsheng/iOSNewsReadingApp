//
//  NewsDetailUIViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewsDetailUIViewController: UIViewController {
    
    /// 新闻视图模型
    var viewModel: NewsViewModel? {
        didSet {
            self.titleLabel = self.viewModel?.newsObject.title
            self.sourceLabel = self.viewModel?.newsObject.source
            self.timeLabel = self.viewModel?.newsObject.publish_time
            self.contentLabel = self.viewModel?.newsObject.content
        }
    }
    private var titleLabel: String?
    private var sourceLabel: String?
    private var timeLabel: String?
    private var contentLabel: String?
    // 评论按钮
    private var inputButton = UIButton(title: "点此评论：说点什么吧~", fontSize: 14, color: .gray, bgColor: .white)
    // 查看评论按钮
    private var  viewCommentButton = UIButton(title: "查看评论", fontSize: 14, color: .systemBlue, bgColor: .clear)
    // 点赞按钮
    private var likeButton = UIButton(title: "点赞", fontSize: 14, color: .systemBlue, bgColor: .clear)
    private var scroview = UIScrollView()
    private var customInputView:CustomInputView?
    private var text = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        SVProgressHUD.show()
        self.viewModel?.loadNewsContent(finished: { (isSuccessed) in
            SVProgressHUD.dismiss()
            if isSuccessed {
                self.contentLabel = self.viewModel?.newsObject.content
                self.text.rz_colorfulConfer { (confer) in
                      confer.paragraphStyle?.lineSpacing(5).paragraphSpacingBefore(10)
                      confer.text(self.titleLabel)?.font(UIFont.systemFont(ofSize: 20))
                      confer.text("\n")
                      confer.text(self.sourceLabel)?.font(UIFont.systemFont(ofSize: 14)).textColor(.systemBlue)
                      confer.text("  ")
                      confer.text(self.timeLabel)?.font(UIFont.systemFont(ofSize: 14)).textColor(.gray)
                      confer.text("\n")
                      confer.htmlString(self.contentLabel)
                      confer.text("\n")
                  }
            } else {
                SVProgressHUD.showError(withStatus: "内容加载失败！请返回")
            }
        })
        setupUI()
        addTarget()
        // Do any additional setup after loading the view.
    }
    @objc func inputButtonClick () {
        self.customInputView = CustomInputView.instance(superView: self.view)
        self.customInputView?.delegate = self
    }
    /// MARK : 查看评论按钮被点击
    @objc func viewCommentButtonClick () {
        let commentsPage = CommentsTableViewController(newsid: (viewModel?.newsObject.id)!)
        self.navigationController?.pushViewController(commentsPage, animated: true)
    }
    @objc func likeButtonClick () {
        print("点赞按钮")
    }
    func addTarget() {
        inputButton.addTarget(self, action: #selector(inputButtonClick), for: .touchUpInside)
        viewCommentButton.addTarget(self, action: #selector(viewCommentButtonClick), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)

    }
    @objc func readAll () {
        if SpeechUtteranceManager.shared.speechSynthesizer.isSpeaking {
            // 停止播放
            SpeechUtteranceManager.shared.speechSynthesizer.stopSpeaking(at: .immediate)
            self.navigationItem.rightBarButtonItem?.title = "朗读全文"
        } else {
            // 开始播放
            SpeechUtteranceManager.shared.handleSpeechUtterance(string: self.text.text ?? "暂无内容，朗读失败。")
            self.navigationItem.rightBarButtonItem?.title = "停止朗读"
        }
    }
    func setupUI() {
        scroview.frame = self.view.bounds
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "朗读全文", style: .plain, target: self, action: #selector(readAll))
        let bottomField = UIView()
        bottomField.backgroundColor = UIColor.hex("eeeeee", alpha: 1.0)

        
        inputButton.layer.borderWidth = 1
        inputButton.layer.cornerRadius = 20
        inputButton.layer.masksToBounds = true
        inputButton.layer.borderColor = UIColor.hex("eeeeee", alpha: 1.0).cgColor
        inputButton.titleLabel?.textAlignment = .left
        
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(scroview)
        
        
        scroview.addSubview(text)
        scroview.addSubview(bottomField)
        
        bottomField.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp_bottom)
            make.height.equalTo(60)
            make.width.equalTo(self.view.snp_width)
        }
        
        bottomField.addSubview(inputButton)
        bottomField.addSubview(likeButton)
        bottomField.addSubview(viewCommentButton)
        
        inputButton.snp_makeConstraints { (make) in
            make.left.equalTo(bottomField.snp_left).offset(10)
            make.centerY.equalTo(bottomField.snp_centerY)
            make.width.equalTo(230)
            make.height.equalTo(40)
        }
        viewCommentButton.snp_makeConstraints { (make) in
            make.left.equalTo(inputButton.snp_right).offset(20)
            make.centerY.equalTo(inputButton.snp_centerY)
        }
        likeButton.snp_makeConstraints { (make) in
            make.left.equalTo(viewCommentButton.snp_right).offset(10)
            make.centerY.equalTo(inputButton.snp_centerY)
        }
        
        
        text.snp_makeConstraints { (make) in
            make.top.equalTo(scroview.snp_top)
            make.width.equalTo(scroview.snp_width)
            make.height.equalTo(self.view.snp_height).offset(-120)
        }
        
        text.isEditable = false
        text.delegate = self
        
    }
    deinit {
        print("NewsDetail 销毁")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }

}

extension NewsDetailUIViewController : UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("url:\(URL)")
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("url:\(URL)")
        return false
    }
}

extension NewsDetailUIViewController: CustomInputViewDelegate {
    
    func send(text: String) {
        NetworkTools.sharedTools.sendComment(newsid: String((self.viewModel?.getNewsID())!), uid: UserAccountViewModel.sharedUserAccount.getUID(), content: text, parentid: "-1") { (res, err) in
            if err != nil {
                SVProgressHUD.showError(withStatus: "评论失败，请重试！")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "评论成功！")
            self.customInputView?.dismiss()
            self.viewCommentButtonClick()
        }
    }
}
