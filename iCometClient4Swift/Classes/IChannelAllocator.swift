//
//  IChannelAllocator.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

protocol IChannelAllocator {
    /**
    * 该方法必须返回 Channel 的实例
    *
    * @return Channel channel
    */
    func allocate() -> Channel
}
