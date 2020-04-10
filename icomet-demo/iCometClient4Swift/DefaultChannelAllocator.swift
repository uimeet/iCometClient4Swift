//
//  DefaultChannelAllocator.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

class DefaultChannelAllocator: IChannelAllocator {
    
    func allocate() -> Channel {
        return Channel()
    }
}
