//
//  MainViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SCLAlertView


class MainViewController: UITabBarController {
    
    
    //MARK: - 语音识别功能相关
    fileprivate var recordRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recordTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate lazy var recognizer: SFSpeechRecognizer = {//
        let recognize = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        recognize?.delegate = self
        return recognize!
    }()
    // 新闻数据列表模型
    private lazy var listViewModel = NewsListViewModel()
    
    //MARK: - 录音按钮
    private lazy var micRecordBtn: UIButton = UIButton(imageName: "tabbar_mic_btn", backgroundColor: UIColor.lightText, width: 30)
    
    // 识别的文本
    private var voiceText:String?
    // 弹窗返回的响应器
    private var alertViewResponder:SCLAlertViewResponder?
    
    // MARK: - 实时录音结束按钮
    @objc private func firstButtonOver() {
        
        stopRecognize()
        print("说完了")
        if self.voiceText?.contains("热点新闻") == true {
            listViewModel.loadNetEaseNews(type: "BBM54PGAwangning", number: "10") { (boolRes) in
                if boolRes {
                    var readText:String = "好的，"
                    var index = 1
                    for obj in self.listViewModel.newsList {
                        readText += "。第\(index)条新闻："
                        readText += obj.newsObject.title
                        index += 1
                    }
                    SpeechUtteranceManager.shared.handleSpeechUtterance(string:readText )
                } else {
                    SpeechUtteranceManager.shared.handleSpeechUtterance(string:"对不起，热点新闻获取失败" )
                }
            }
        } else {
            SpeechUtteranceManager.shared.handleSpeechUtterance(string:"对不起，听不懂您在说什么")
        }
    }
    // 开始/停止录音
    @objc private func clickMicRecordBtn() {
        // 初始化弹窗对象
        let alertView:SCLAlertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false ))
        alertView.addButton("说完了", target:self, selector:#selector(firstButtonOver))
     
        
        if SpeechUtteranceManager.shared.speechSynthesizer.isSpeaking {
            // 停止播放语音
            SpeechUtteranceManager.shared.speechSynthesizer.stopSpeaking(at: .immediate)
        } else {
            startRecognize()
            alertViewResponder = alertView.showWait("正在识别语音中...", subTitle: "...")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 会创建tabBar中所有控制器对应的按钮
        super.viewWillAppear(animated)
        
        // 将录音按钮层级置顶
        tabBar.bringSubviewToFront(micRecordBtn)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
        
        setupRecordButton()
        
        // 请求录音权限
        addSpeechRecordLimit()
    }
    
    private func setupRecordButton() {
        // 1.添加按钮
        tabBar.addSubview(micRecordBtn)
        // 2.调整按钮
        let count = children.count
        // 3. -1 是让按钮宽一点，能够解决手指点击的容错问题
        let w = tabBar.bounds.width / CGFloat(count) - 1
        micRecordBtn.frame = tabBar.bounds.insetBy(dx: 2*w,dy: 0)
        // 4. 添加监听方法
        micRecordBtn.addTarget(self, action:#selector(clickMicRecordBtn), for: .touchUpInside)
        
    }
    
    private func addChildViewControllers() {
        addChild(vc: HomeTableViewController(), title: "首页热点", imageName: "tabbar_home")
        addChild(vc: ClassifyTableViewController(), title: "分类新闻", imageName: "tabbar_classify")
        
        addChild(UIViewController())
        
        addChild(vc: DiscoverTableViewController(), title: "发现更多", imageName: "tabbar_discover")
        addChild(vc: ProfileTableViewController(), title: "用户中心", imageName: "tabbar_profile")
    }
    
    private func addChild(vc: UIViewController, title: String, imageName: String) {
        // 实例化导航视图控制器
        let nav = UINavigationController(rootViewController: vc)
        
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)?.resizeImage(newWidth: 30)
        
        // 添加
        addChild(nav)
    }
    

}
//MARK: 录音识别
extension MainViewController{
    //开始识别
    fileprivate func startRecognize(){
        //1. 停止当前任务
        stopRecognize()
        
        //2. 创建音频会话
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSession.Category.record)
            try session.setMode(AVAudioSession.Mode.measurement)
            //激活Session
            try session.setActive(true)
        }catch{
            print("Throws：\(error)")
        }
        
        //3. 创建识别请求
        recordRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        //开始识别获取文字
        recordTask = recognizer.recognitionTask(with: recordRequest!, resultHandler: { (result, error) in
            if result != nil {
                var text = ""
                for trans in result!.transcriptions{
                    text += trans.formattedString
                }
                
                self.alertViewResponder?.setSubTitle(text)
                self.voiceText = text
                
                if result!.isFinal{
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recordRequest = nil
                    self.recordTask = nil
//                    self.recordBtn.isEnabled = true
                }
            }
        })
        let recordFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordFormat, block: { (buffer, time) in
            self.recordRequest?.append(buffer)
        })
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Throws：\(error)")
        }
    }
    
    //停止识别
    fileprivate func stopRecognize(){
        if recordTask != nil{
            recordTask?.cancel()
            recordTask = nil
        }
        removeTask()
    }
    
    //销毁录音任务
    fileprivate func removeTask(){
        self.audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        self.recordRequest = nil
        self.recordTask = nil
//        self.recordBtn.isEnabled = true
    }
    
    ///语音识别权限认证
    fileprivate func addSpeechRecordLimit(){
        SFSpeechRecognizer.requestAuthorization { (state) in
            var isEnable = false
            switch state {
            case .authorized:
                isEnable = true
                print("已授权语音识别")
            case .notDetermined:
                isEnable = false
                print("没有授权语音识别")
            case .denied:
                isEnable = false
                print("用户已拒绝访问语音识别")
            case .restricted:
                isEnable = false
                print("不能在该设备上进行语音识别")
            @unknown default:
                fatalError()
            }
            DispatchQueue.main.async {
                self.micRecordBtn.isEnabled = isEnable
            }
        }
    }
}

//MARK: 代理
extension MainViewController: SFSpeechRecognizerDelegate{
    //监视语音识别器的可用性
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        micRecordBtn.isEnabled = available
    }
}
