//
//  ICometCallback.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation


public protocol ICometCallback {
    
    /**
    * 收到 TYPE_DATA 消息时回调
    * @param content 消息内容
    */
    func onDataMsgArrived(content: Message.Content) -> Void
    
    /**
    * 任意消息到达时回调，可能不是 TYPE_DATA 消息
    * @param msg 消息对象
    */
    func onMsgArrived(msg: Message) -> Void
    
    /**
    * 收到错误消息时回调
    * @param msg 消息对象
    */
    func onErrorMsgArrived(msg: Message) -> Void
    
    /**
    * 收到 TYPE_401 消息时回调
    * 一般情况需要在此回调中去申请新的token，如果返回null或空字符串连接将退出
    * @return
    */
    func onUnAuthorizedErrorMsgArrived() -> String?
    
    /**
    * 消息格式错误时回调，如客户端收到的消息不是一个json时
    */
    func onMsgFormatError(msg: Message?) -> Void
}
