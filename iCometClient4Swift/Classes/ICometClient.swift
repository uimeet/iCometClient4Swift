//
//  ICometClient.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

public class ICometClient: ICometConnectionDataDelegate {
    
    // 连接服务端使用的完整URL
    private var finalUrl: String = ""
    // 重连次数
    private var reconnTimes: Int32 = 0
    // 连接的频道
    private var channel: Channel? = nil
    
    private var icometCallback: ICometCallback? = nil
    private var iconnectionCallback: IConnectionCallback? = nil
    
    private var connection: ICometConnection? = nil
    
    private var conf: ICometConf? = nil
    
    private var status: ClientState = ClientState.NEW
    
    public init() {}
    
    /**
     准备连接
     @param conf
     */
    public func prepare(conf: ICometConf) -> Void {
        NSLog("[prepare]\(conf)")
        
        if conf.channelAllocator == nil {
            conf.channelAllocator = DefaultChannelAllocator()
            NSLog("[prepare]use DefaultChannelAllocator")
        }
        self.conf = conf
        if reconnTimes == 0 {
            self.channel = conf.channelAllocator?.allocate()
        }
        self.finalUrl = self.buildURL(url: conf.url)
        self.icometCallback = conf.iCometCallback
        self.iconnectionCallback = conf.iConnCallback
        self.status = ClientState.READY
        
        NSLog("[prepare]status change to [READY], finalUrl: \(self.finalUrl)")
        
    }
    
    public func connect() {
        NSLog("[connect]STATUS: \(self.status)")
        if self.status != ClientState.READY {
            return
        }
        
        self.connection = ICometConnection(url: self.finalUrl, dataDelegate: self)
        self.connection?.startStreaming()
        
    }
    
    public func stopConnect() {
        NSLog("[stopConnect]")
        self.status = ClientState.STOP_PENDING
        if self.connection != nil {
            self.connection?.stopStreaming(true)
            self.connection = nil
        }
    }
    
    private func reconnect(immediate: Bool) {
        NSLog("[reconnect]call")
        if self.iconnectionCallback == nil {
            NSLog("[iconnectionCallback == null]exit reconnect")
            return
        }
        
        if immediate {
            self.reconnectImmediate()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.reconnectImmediate()
            }
        }
    }
    
    private func reconnectImmediate() {
        if !(self.iconnectionCallback?.onReconnect(times: self.reconnTimes))! {
            self.reconnTimes += 1
            if self.status != ClientState.READY {
                self.prepare(conf: self.conf!)
            }
            NSLog("[reconnect]start")
            self.connect()
        }
    }
    
    private func disconnect() {
        self.status = ClientState.DISCONNECT
        if self.iconnectionCallback != nil {
            self.iconnectionCallback?.onDisconnect()
        }
    }
    
    /**
     创建完整的通知连接
     */
    private func buildURL(url: String) -> String {
        var urlParts = [String]()
        if !self.conf!.host.hasPrefix("http") {
            urlParts.append(self.conf!.enableSSL ? "https://" : "http://")
        }
        urlParts.append(self.conf!.host)
        if self.conf!.port > 0 && self.conf!.port != 80 && self.conf!.port != 443 {
            urlParts.append(":\(String(self.conf!.port))")
        }
        if self.conf!.url != "" {
            if !self.conf!.url.hasPrefix("/") {
                urlParts.append("/")
            }
            urlParts.append(self.conf!.url)
        }
        if self.channel != nil {
            urlParts.append("?")
            urlParts.append("cname=\(self.channel!.cname)")
            urlParts.append("&seq=\(self.channel!.seq)")
            urlParts.append("&token=\(self.channel!.token)")
        }
        return urlParts.joined(separator: "")
    }
    
    
    func onMessageArrived(message: Message) {
        // 消息到达回调
        self.icometCallback?.onMsgArrived(msg: message)
        
        switch message.type {
        case MessageType.TYPE_BROADCAST, MessageType.TYPE_DATA:
            // 数据消息回调
            self.icometCallback?.onDataMsgArrived(content: message.contentJSON)
            break
        case MessageType.TYPE_NEXT_SEQ:
            // 连接成功回调
            if self.iconnectionCallback != nil && self.status != ClientState.CONNECTED {
                self.status = ClientState.CONNECTED
                NSLog("[connect]status change to [CONNECTED]")
                if self.reconnTimes == 0 {
                    self.iconnectionCallback?.onSuccess()
                } else {
                    self.iconnectionCallback?.onReconnectSuccess(times: self.reconnTimes)
                    self.reconnTimes = 0
                }
            }
        case MessageType.TYPE_NOOP:
            // 心跳消息不用处理
            break;
        case MessageType.TYPE_401:
            NSLog("token expired, renew...")
            // 获取新的token
            let token = self.icometCallback?.onUnAuthorizedErrorMsgArrived()
            if (token != nil && token != "") {
                self.channel?.token = token!
            }
        default:
            // 错误消息回调
            self.icometCallback?.onErrorMsgArrived(msg: message)
            break
        }
        
    }
    
    func onError(error: Error) {
        NSLog("ICometClient.onError: \(error.localizedDescription)")
        if self.iconnectionCallback != nil {
            self.iconnectionCallback?.onFail(msg: error.localizedDescription)
        }
        self.reconnect(immediate: false)
    }
    
    func onClose() {
        self.status = ClientState.STOP
        // 用户主动关闭回调
        self.iconnectionCallback?.onStop()
    }
    
    func onCompleted() {
        self.status = ClientState.DISCONNECT
        // 进行重连
        self.reconnect(immediate: false)
    }
    
}

enum ClientState {
    // client 刚创建时的状态
    case NEW
    // client 已就绪
    case READY
    // client 已成功连接服务端
    case CONNECTED
    // client 工作中状态（发送/接受消息）
    case COMET
    // client 被主动停止的状态
    case STOP
    // 停止刮起状态
    case STOP_PENDING
    // 由服务端断开连接时的状态，此时通常发生了错误
    case DISCONNECT
}
