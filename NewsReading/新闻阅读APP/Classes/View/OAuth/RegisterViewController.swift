//
//  VisitorRegisterController.swift
//  新闻阅读APP
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking
import SwiftyJSON

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    var labelUsername:UILabel = UILabel(title: "请输入注册的用户名：", fontSize: 18)
    var labelPassword:UILabel = UILabel(title: "请设定一个密码：", fontSize: 18)
    var labelConfirmPassword:UILabel = UILabel(title: "重复输入确认密码：", fontSize: 18)
    var labelTelephone:UILabel = UILabel(title: "请输入手机号（用来找回密码）：", fontSize: 18)
    var txtTelephone:UITextField = UITextField()
    var txtUsername:UITextField = UITextField()
    var txtPassword:UITextField = UITextField()
    var txtConfirmPassword:UITextField = UITextField()
    private lazy var registerButton:UIButton = UIButton(title: "立即注册", color: UIColor.black, backImageName: "common_button_white_disable")

    // 注册界面的头图
    private lazy var headImage:UIImageView = UIImageView(imageName: "register")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        let borderRegister : UIView = UIView()
        borderRegister.layer.borderWidth = 0.5
        borderRegister.layer.borderColor = UIColor.lightGray.cgColor
        let gap = 10
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        self.navigationItem.title = "注册新用户"
        self.view.addSubview(headImage)
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(borderRegister)
        
        self.view.addSubview(labelUsername)
        self.view.addSubview(labelPassword)
        self.view.addSubview(labelConfirmPassword)
        self.view.addSubview(labelTelephone)
        
        self.view.addSubview(txtUsername)
        self.view.addSubview(txtPassword)
        self.view.addSubview(txtTelephone)
        self.view.addSubview(txtConfirmPassword)
        
        self.view.addSubview(registerButton)
        
        headImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(view.snp_top).offset(100)
        }
        borderRegister.snp_makeConstraints { (make) in
            make.width.equalTo(view.snp_width).offset(-40)
            make.top.equalTo(headImage.snp_bottom).offset(30)
            make.height.equalTo(400)
            make.left.equalTo(20)
        }
        labelUsername.snp_makeConstraints { (make) in
            make.top.equalTo(borderRegister.snp_top).offset(gap)
            make.left.equalTo(borderRegister.snp_left).offset(gap)
        }
        txtUsername.layer.cornerRadius = 5
        txtUsername.layer.borderColor = UIColor.lightGray.cgColor
        txtUsername.layer.borderWidth = 0.5
        txtUsername.snp_makeConstraints { (make) in
            make.top.equalTo(labelUsername.snp_bottom).offset(gap)
            make.width.equalTo(borderRegister.snp_width).offset(-gap*2)
            make.left.equalTo(borderRegister.snp_left).offset(gap)
            make.height.equalTo(40)
        }
        labelPassword.snp_makeConstraints { (make) in
            make.top.equalTo(txtUsername.snp_bottom).offset(gap)
            make.left.equalTo(txtUsername.snp_left)
        }
        txtPassword.layer.cornerRadius = 5
        txtPassword.layer.borderColor = UIColor.lightGray.cgColor
        txtPassword.layer.borderWidth = 0.5
        txtPassword.isSecureTextEntry = true
        txtPassword.snp_makeConstraints { (make) in
            make.top.equalTo(labelPassword.snp_bottom).offset(gap)
            make.width.equalTo(txtUsername)
            make.left.equalTo(txtUsername.snp_left)
            make.height.equalTo(txtUsername.snp_height)
        }
        labelConfirmPassword.snp_makeConstraints { (make) in
             make.top.equalTo(txtPassword.snp_bottom).offset(gap)
             make.left.equalTo(labelPassword.snp_left)
         }
        txtConfirmPassword.layer.cornerRadius = 5
        txtConfirmPassword.layer.borderColor = UIColor.lightGray.cgColor
        txtConfirmPassword.layer.borderWidth = 0.5
        txtConfirmPassword.isSecureTextEntry = true
        txtConfirmPassword.snp_makeConstraints { (make) in
             make.top.equalTo(labelConfirmPassword.snp_bottom).offset(gap)
             make.width.equalTo(txtUsername)
             make.left.equalTo(txtUsername.snp_left)
             make.height.equalTo(txtUsername.snp_height)
         }
        labelTelephone.snp_makeConstraints { (make) in
              make.top.equalTo(txtConfirmPassword.snp_bottom).offset(gap)
              make.left.equalTo(labelPassword.snp_left)
        }
        txtTelephone.layer.cornerRadius = 5
        txtTelephone.layer.borderColor = UIColor.lightGray.cgColor
        txtTelephone.layer.borderWidth = 0.5
        txtTelephone.snp_makeConstraints { (make) in
             make.top.equalTo(labelTelephone.snp_bottom).offset(gap)
             make.width.equalTo(txtUsername)
             make.left.equalTo(txtUsername.snp_left)
             make.height.equalTo(txtUsername.snp_height)
         }
        registerButton.snp_makeConstraints { (make) in
            make.top.equalTo(txtTelephone.snp_bottom).offset(gap+10)
            make.centerX.equalTo(borderRegister.snp_centerX)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        
    }
    
}
