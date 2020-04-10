//
//  AppDelegate.swift
//  iCometClient4Swift
//
//  Created by uimeet on 04/10/2020.
//  Copyright (c) 2020 uimeet. All rights reserved.
//

import UIKit
import iCometClient4Swift

class MyChannelAllocator: IChannelAllocator {
    func allocate() -> Channel {
        return Channel(cname: "DY_58", token: "", seq: 0)
    }
    
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ICometCallback, IConnectionCallback {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let client = ICometClient()
            client.prepare(conf: ICometConf(host: "192.168.0.52", port: 8888, url: "/ic/stream", iCometCallback: self, channelAllocator: MyChannelAllocator(), iConnCallback: self, enableSSL: false))
            client.connect()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        return "45c0437d67f30f875af640a378e92d43"
    }
    
    func onMsgFormatError(msg: Message?) {
        NSLog("onMsgFormatError: \(String(describing: msg))")
    }

}

