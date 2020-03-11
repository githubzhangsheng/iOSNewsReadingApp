//
//  JavaScriptTools.swift
//  新闻阅读APP
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate:JSExport{
    
     func logout()

     func showAlert(_ str:String,_ msg:String)

}

@objc class SwiftJavaScriptModel:NSObject,SwiftJavaScriptDelegate{
    func logout() {
        print("登出")
    }
    
    

    func showAlert(_ str:String,_ msg:String){
        print("js调用我了:",str,msg)

    }

}

 
