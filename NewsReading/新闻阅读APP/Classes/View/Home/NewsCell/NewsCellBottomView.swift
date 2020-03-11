//
//  NewsCellBottomView.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AVFoundation

/// 新闻cell底部视图
class NewsCellBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTarget()
    }
    
    var contentText : String?
    
    /// 新闻视图模型
    var viewModel: NewsViewModel? {
        didSet {
            contentText = "新闻标题:" + (self.viewModel?.newsObject.title)!
            contentText! += "，新闻来源："+(self.viewModel?.newsObject.source)!
            contentText! += "，新闻内容如下：" + (self.viewModel?.newsObject.content)!
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 懒加载控件
    /// 朗读按钮
    private lazy var voiceButton: UIButton = UIButton(title: " 开始朗读", fontSize: 12, color: UIColor.darkGray, imageName: "play", width:18)
    /// 评论按钮
    private lazy var commentButton: UIButton = UIButton(title: " 评论", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_comment")
    /// 点赞按钮
    private lazy var likeButton: UIButton = UIButton(title: " 点赞", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_unlike")
    
}

extension NewsCellBottomView {
    
    private func setupUI() {
        // 1. 添加控件
        addSubview(voiceButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        // 2. 自动布局
        voiceButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top)
            make.left.equalTo(self.snp_left)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        commentButton.snp_makeConstraints { (make) in
            make.top.equalTo(voiceButton.snp_top)
            make.left.equalTo(voiceButton.snp_right)
            make.width.equalTo(voiceButton.snp_width)
            make.height.equalTo(voiceButton.snp_height)
        }
        
        likeButton.snp_makeConstraints { (make) in
            make.top.equalTo(commentButton.snp_top)
            make.left.equalTo(commentButton.snp_right)
            make.width.equalTo(commentButton.snp_width)
            make.height.equalTo(commentButton.snp_height)
            
            make.right.equalTo(self.snp_right)
        }
        
        // 分隔视图
        let sep1 = sepView()
        let sep2 = sepView()
        addSubview(sep1)
        addSubview(sep2)

        // 布局
        let w = 0.5
        let scale = 0.4

        sep1.snp_makeConstraints { (make) in
            make.left.equalTo(voiceButton.snp_right)
            make.centerY.equalTo(voiceButton.snp_centerY)
            make.width.equalTo(w)
            make.height.equalTo(voiceButton.snp_height).multipliedBy(scale)
        }
        sep2.snp_makeConstraints { (make) in
            make.left.equalTo(commentButton.snp_right)
            make.centerY.equalTo(voiceButton.snp_centerY)
            make.width.equalTo(w)
            make.height.equalTo(voiceButton.snp_height).multipliedBy(scale)
        }
    }
    private func addTarget() {
        voiceButton.addTarget(self, action: #selector(voiceBtnClick), for: .touchUpInside)
    }
    @objc private func voiceBtnClick() {
        
        if SpeechUtteranceManager.shared.speechSynthesizer.isSpeaking {
            // 停止播放
            SpeechUtteranceManager.shared.speechSynthesizer.stopSpeaking(at: .immediate)
            configureStopSpeakingUI()
        } else {
            // 开始播放
            SpeechUtteranceManager.shared.speechSynthesizer.delegate = self
            SpeechUtteranceManager.shared.handleSpeechUtterance(string: self.contentText ?? "暂无内容，朗读失败。")
            configureStartSpeakingUI()
        }
    }
    /// 播放结束执行的事件
    func configureStopSpeakingUI() {
        voiceButton.setImage(UIImage(named: "play")?.resizeImage(newWidth: 18), for: .normal)
        voiceButton.setTitle(" 开始朗读", for: .normal)
    }
    func configureStartSpeakingUI() {
        voiceButton.setImage(UIImage(named: "stop")?.resizeImage(newWidth: 18), for: .normal)
        voiceButton.setTitle(" 停止朗读", for: .normal)
    }
    
    /// 创建分隔视图 
    private func sepView() -> UIView {
        let v = UIView()
        
        v.backgroundColor = UIColor.darkGray
        
        return v
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension NewsCellBottomView: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("開始播放")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("暫停播放")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("繼續播放")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        configureStopSpeakingUI()
        print("播放結束")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        configureStopSpeakingUI()
        print("取消播放")
    }
    
//    // 播放時，可通過此方法監聽當前播放的字或詞
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
//
//        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
//        mutableAttributedString.addAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18)], range: NSMakeRange(0, mutableAttributedString.length))
//        mutableAttributedString.addAttributes([.foregroundColor: UIColor.red, .font: UIFont.boldSystemFont(ofSize: 18)], range: characterRange)
//        textView.attributedText = mutableAttributedString
//    }
}
