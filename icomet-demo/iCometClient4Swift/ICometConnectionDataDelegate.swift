//
//  ICometConnectionDataDelegate.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/10.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

protocol ICometConnectionDataDelegate {
    
    /**
     当消息到达时回调
     @param message 消息内容
     */
    func onMessageArrived(message: Message) -> Void;
    
    /**
     当连接发送错误时回调
     @param error 错误内容，如果为nil表示不是发生的 HTTP 错误，而是由服务端终端关闭连接
                比如服务端返回 401 消息时
     */
    func onError(error: Error) -> Void;
    
    /**
     当连接执行完成时回调
     */
    func onCompleted() -> Void;
    
    /**
     当连接被主动关闭时回调
     */
    func onClose() -> Void;
    
}
