//
//  LoginViewController.swift
//  新闻阅读APP
//
//  Created by mac on 2019/12/1.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking
import SwiftyJSON

//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}

// 用户登录控制器
class LoginViewController: UIViewController,UITextFieldDelegate {

    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    
    //左手离脑袋的距离
    var offsetLeftHand:CGFloat = 60
    
    //左手图片,右手图片(遮眼睛的)
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
    
    //左手图片,右手图片(圆形的)
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
    
    // 登录按钮
    var loginButton:UIButton!
    
    
    //登录框状态
    var showType:LoginShowType = LoginShowType.NONE
    
    //MARK: 监听方法-关闭窗口
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: 登录按钮点击事件
    // 点击登录，校验账号密码长度，post提交，返回登录结果，根据code判断返回结果，拿到token
    // 登录成功后根据 token，用get方法请求userinfo的信息
    @objc private func loginBtnClick() {
        
        // 收回键盘
        self.view.endEditing(true)
        
        // 判断用户名密码框是否为空，为空提醒
        
        // 点击有加载的状态（动画）
        
        // 登录方法
        UserAccountViewModel.sharedUserAccount.userSignIn(username: self.txtUser.text!, password: self.txtPwd.text!) { (type) in
            switch type {
                case 0:
                    SVProgressHUD.showInfo(withStatus: "登录成功!")
                    self.dismiss(animated: true) {
                        SVProgressHUD.dismiss()
                    }
                case 1: SVProgressHUD.showInfo(withStatus: "网路不好!")
                case 2: SVProgressHUD.showInfo(withStatus: "账号密码有误!")
                case 3:SVProgressHUD.showInfo(withStatus: "用户信息加载失败!")
                default: return;
            }
        }
        
    }
    // 键盘点击return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    override var description: String {
//        let keys = ["token","expires","uid","avatar_large","name"]
//        return dictionaryWithValues(forKeys: keys).description
//    }
    // 点击空白处收回键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化UI
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        self.view.backgroundColor = UIColor.white
        
        // 获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        // 猫头鹰头部
        let imgLogin = UIImageView(frame: CGRect(x: mainSize.width/2-211/2, y: 100, width: 211, height: 109))
        imgLogin.image = UIImage(named: "owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
        
        
        //猫头鹰左手(遮眼睛的)
        let rectLeftHand = CGRect(x: 61 - offsetLeftHand, y: 90, width: 40, height: 65)
        imgLeftHand = UIImageView(frame:rectLeftHand)
        imgLeftHand.image = UIImage(named:"owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
        
        //猫头鹰右手(遮眼睛的)
        let rectRightHand = CGRect(x: imgLogin.frame.size.width / 2 + 60, y: 90, width: 40, height: 65)
        imgRightHand = UIImageView(frame:rectRightHand)
        imgRightHand.image = UIImage(named:"owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
        
        //登录框背景  height 160
        let vLogin =  UIView(frame:CGRect(x: 15, y: 200, width: mainSize.width - 30, height: 240))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //猫头鹰左手(圆形的)
        let rectLeftHandGone = CGRect(x: mainSize.width / 2 - 100,
                                      y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgLeftHandGone = UIImageView(frame:rectLeftHandGone)
        imgLeftHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgLeftHandGone)
        
        //猫头鹰右手(圆形的)
        let rectRightHandGone = CGRect(x: mainSize.width / 2 + 62,
                                       y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgRightHandGone = UIImageView(frame:rectRightHandGone)
        imgRightHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgRightHandGone)
        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.placeholder = "请输入用户名"
        txtUser.leftViewMode = UITextField.ViewMode.always
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextField.ViewMode.always
        txtPwd.placeholder = "请输入密码"
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
        
        
        // 登录按钮
        let loginBtn = CGRect(x: 30, y: 160, width: vLogin.frame.size.width - 60, height: 44)
        loginButton = UIButton(frame: loginBtn)
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        loginButton.backgroundColor = UIColor.brown
        loginButton.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        vLogin.addSubview(loginButton)
        
    }
    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        //如果当前是用户名输入
        if textField.isEqual(txtUser){
            if (showType != LoginShowType.PASS)
            {
                showType = LoginShowType.USER
                return
            }
            showType = LoginShowType.USER
            
            
            UIView.animate(withDuration: 0.5) {
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x - self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y + 30,
                    width: self.imgLeftHand.frame.size.width,
                    height: self.imgLeftHand.frame.size.height)
                
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x + 48,
                    y: self.imgRightHand.frame.origin.y + 30,
                    width: self.imgRightHand.frame.size.width,
                    height: self.imgRightHand.frame.size.height)
                
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x - 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 40, height: 40)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x + 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 40, height: 40)
            }
            
        }
        //如果当前是密码名输入
        else if textField.isEqual(txtPwd){
            if (showType == LoginShowType.PASS)
            {
                showType = LoginShowType.PASS
                return
            }
            showType = LoginShowType.PASS
            
            //播放遮眼动画
            UIView.animate(withDuration: 0.5, animations: {
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x + self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y - 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x - 48,
                    y: self.imgRightHand.frame.origin.y - 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x + 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 0, height: 0)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x - 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 0, height: 0)
            })
        }
    }

}
