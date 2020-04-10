//
//  Channel.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

public struct Channel {
    // 渠道名称
    public var cname: String = ""
    
    // 接口调用口令，由服务端下发
    public var token: String = ""
    
    // 消息读取的位置，该值应该被递增，如果传入 0 则不收取历史消息，传入 1 将收取所有历史消息
    // 注：服务端只会保留最近 10 条消息
    public var seq: Int32 = 0
    
    public init(cname: String = "", token: String = "", seq: Int32 = 0) {
        self.cname = cname
        self.token = token
        self.seq = seq
    }
    
}
