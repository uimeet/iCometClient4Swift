//
//  SceneDelegate.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import UIKit
import SwiftUI

class MyChannelAllocator: IChannelAllocator {
    func allocate() -> Channel {
        return Channel(cname: "DY_58", token: "", seq: 0)
    }
    
    
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ICometCallback, IConnectionCallback {
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
    

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
        print("test start")
        let client = ICometClient()
            client.prepare(conf: ICometConf(host: "192.168.0.52", port: 8888, url: "/ic/stream", iCometCallback: self, channelAllocator: MyChannelAllocator(), iConnCallback: self, enableSSL: false))
            client.connect()
//        if (NetworkManager.shared.isStreaming) {
//            NetworkManager.shared.stopStreaming()
//        } else {
//            NetworkManager.shared.startStreaming(url: "http://192.168.0.52:8888/ic/stream?cname=DY_58&token=3a1f79f6530cf0a65d61c8b2060014a6")
//        }
//        let url=URL(string:"http://192.168.0.52:8888/ic/stream?cname=DY_58&token=3a1f79f6530cf0a65d61c8b2060014a6")!
////        let url=URL(string: "https://api.kemiba.cn/api/app/launch_v2")!
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            print("test4");
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
//        }
//        print("test2")
//        task.resume()
        print("test end");
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

