//
//  AVoiceTools.swift
//  新闻阅读APP
//
//  Created by mac on 2020/2/8.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechUtteranceManager: NSObject {
    // 单例
    public static let shared = SpeechUtteranceManager()
    
    // 文字转语音
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
    }
    
    func handleSpeechUtterance(string: String) {
        
        let speechUtterance = AVSpeechUtterance(string: string)

        // 設定語音語言
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        
        // 語速 0~1
        speechUtterance.rate = 0.5
        
        // 音調 [0.5 - 2] Default = 1
        speechUtterance.pitchMultiplier = 1.0
        
        // 音量 [0-1] Default = 1
        speechUtterance.volume = 1

        // 播放合成語音
        speechSynthesizer.speak(speechUtterance)
    }
  
}
