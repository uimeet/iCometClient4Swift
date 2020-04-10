//
//  ICometConnectionCallback.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

protocol IConnectionCallback {
    /**
     * 连接 Comet 服务端失败时回调
     * @param msg
     */
    func onFail(msg: String) -> Void

    /**
     * 连接 Comet 服务端成功时回调
     */
    func onSuccess() -> Void

    /**
     * 连接被服务端断开或发送链路错误时回调
     */
    func onDisconnect() -> Void

    /**
     * 连接由用户主动断开时回调
     */
    func onStop() -> Void

    /**
     * 当客户端需要重连服务端时回调
     * @param times 显示当前是第几次重连
     * @return 返回一个布尔值，true 表示停止重连，false 表示继续重连
     */
    func onReconnect(times: Int32) -> Bool

    /**
     * 重连服务端成功时回调
     * @param times
     */
    func onReconnectSuccess(times: Int32) -> Void
}
