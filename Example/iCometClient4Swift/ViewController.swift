//
//  ViewController.swift
//  iCometClient4Swift
//
//  Created by uimeet on 04/10/2020.
//  Copyright (c) 2020 uimeet. All rights reserved.
//

import UIKit
import iCometClient4Swift

class ViewController: UIViewController, ICometCallback, IConnectionCallback {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("start")
        let client = ICometClient()
            client.prepare(conf: ICometConf(host: "192.168.0.52", port: 8888, url: "/ic/stream", iCometCallback: self, channelAllocator: MyChannelAllocator(), iConnCallback: self, enableSSL: false))
            client.connect()
        
        //timer.fire()
            
        print("end")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onFail(msg: String) {
        NSLog("onFail: \(msg)")
    }
    
    func onSuccess() {
        NSLog("onSuccess")
    }
    
    func onDisconnect() {
        NSLog("onDisconnect")
    }
    
    func onStop() {
        NSLog("onStop")
    }
    
    func onReconnect(times: Int32) -> Bool {
        NSLog("onReconnect: \(times)")
        return false
    }
    
    func onReconnectSuccess(times: Int32) {
        NSLog("onReconnectSuccess: \(times)")
    }
    
    func onDataMsgArrived(content: Message.Content) {
        NSLog("onDataMsgArrived: \(content)")
    }
    
    func onMsgArrived(msg: Message) {
        NSLog("onMsgArrived: \(msg)")
    }
    
    func onErrorMsgArrived(msg: Message) {
        NSLog("onErrorMsgArrived: \(msg)")
    }
    
    func onUnAuthorizedErrorMsgArrived() -> String? {
        return "1b2b803f2cc107e46ce0c8ad15992194"
    }
    
    func onMsgFormatError(msg: Message?) {
        NSLog("onMsgFormatError: \(String(describing: msg))")
    }

}

