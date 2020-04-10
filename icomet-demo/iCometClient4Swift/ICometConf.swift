//
//  ICometConf.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

class ICometConf {
    let host: String
    let port: Int32
    let url: String
    let enableSSL: Bool
    
    var channelAllocator: IChannelAllocator?
    var iCometCallback: ICometCallback
    var iConnCallback: IConnectionCallback?
    
    init(host: String, port: Int32, url: String, iCometCallback: ICometCallback, channelAllocator: IChannelAllocator? = nil, iConnCallback: IConnectionCallback? = nil, enableSSL: Bool = false) {
        self.host = host
        self.port = port
        self.url = url
        
        self.channelAllocator = channelAllocator
        self.iCometCallback = iCometCallback
        self.iConnCallback = iConnCallback
        
        self.enableSSL = enableSSL
    }
    
    public var description: String {
        return "ICometConf(\(self.enableSSL ? "https" : "http")://\(self.host):\(self.port)/\(self.url))"
    }
}
