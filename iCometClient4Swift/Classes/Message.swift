//
//  Message.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

public struct Message {
    
    // 消息类型
    let type: MessageType
    
    // 频道名
    let cname: String
    
    // 消息位置
    let seq: Int64
    
    // 消息内容
    let content: String
    
    // 未知类型消息
    static let Unknown: Message = Message(type: MessageType.TYPE_UNKNOWN, cname: "", seq: 0, content: MessageType.TYPE_UNKNOWN.rawValue)
    
    var contentJSON: Content {
        NSLog("call contentJSON")
        if self.type == MessageType.TYPE_DATA || self.type == MessageType.TYPE_BROADCAST {
            do {
                let dataJson = try JSONSerialization.jsonObject(with: self.content.data(using: .utf8)!, options: .mutableContainers) as? [String: Any]
                return Content(type: dataJson!["type"]! as! Int32, body: dataJson!["body"]! as? [String: Any], id: dataJson!["id"] as! String)
            } catch {
                return Content.Error
            }
        }
        return Content.Empty
    }
    
    public var description: String {
        return "Message(type=\(self.type), cname=\(self.cname), seq=\(self.seq), content=\(self.content))"
    }

    
    public struct Content: Equatable {
        
        // 错误内容
        static let Error: Content = Content(type: -1, body: nil, id: "<Content.Error>")
        // 空内容
        static let Empty: Content = Content(type: 0, body: nil, id: "<Content.Empty>")
        
        let type: Int32
        let body: [String: Any]?
        let id: String
        
        public var description: String {
            var values = ["type=\(self.type)", "id=\(self.id)"]
            if self.body != nil {
                for (key, value) in self.body! {
                    values.append("\(key)=\(value)")
                }
            }
            return values.joined(separator: ", ")
        }
        
        public static func == (lhs: Message.Content, rhs: Message.Content) -> Bool {
            return lhs.type == rhs.type && lhs.id == rhs.id
        }
        
    }
    
    static func parse(data: Data) -> Message {
        // 转换成json对象
        let dataJson: [String: Any]?
        do {
            dataJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            return Message(type: MessageType(rawValue: dataJson!["type"]! as! String) ?? MessageType.TYPE_UNKNOWN,
                            cname: dataJson!["cname"]! as! String,
                            seq: dataJson!["seq"]! as! Int64,
                            content: dataJson!["content"]! as! String)
        } catch{
            NSLog("[Message.parse]parse error: \(data)")
        }
        
        return Message.Unknown
        
    }
    
     
    
}


enum MessageType: String {
    // 数据消息
    case TYPE_DATA = "data"
    // 广播消息
    case TYPE_BROADCAST = "broadcast"
    // 心跳消息
    case TYPE_NOOP = "noop"
    // 频道消息：订阅者数量超过服务端限制值时返回消息
    case TYPE_429 = "429"
    // token 无效时返回消息
    case TYPE_401 = "401"
    // next_seq 消息通常不需要做处理，该消息只有在客户端第一次连接服务端时才下发
    case TYPE_NEXT_SEQ = "next_seq"
    // 未知类型消息
    case TYPE_UNKNOWN = "unknown"
    
}
