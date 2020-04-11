//
//  ICometConnection.swift
//  icomet-demo
//
//  Created by 田真 on 2020/4/9.
//  Copyright © 2020 田真. All rights reserved.
//

import Foundation

public class ICometConnection: NSObject, URLSessionDataDelegate {

    private var session: URLSession! = nil
    private var dataDelegate: ICometConnectionDataDelegate
    
    private var url: String

    init(url: String, dataDelegate: ICometConnectionDataDelegate) {
        self.url = url
        self.dataDelegate = dataDelegate
        
        super.init()
        
        let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        
    }

    private var streamingTask: URLSessionDataTask? = nil

    var isStreaming: Bool { return self.streamingTask != nil }

    func startStreaming() {
        self.stopStreaming()
        precondition( !self.isStreaming )

        let url = URL(string: self.url)!
        let request = URLRequest(url: url)
        let task = self.session.dataTask(with: request)
        
        self.streamingTask = task
        task.resume()
    }

    func stopStreaming(_ userClose: Bool = false) {
        guard let task = self.streamingTask else {
            return
        }
        self.streamingTask = nil
        task.cancel()
        self.closeStream(userClose)
    }

    var outputStream: OutputStream? = nil

    private func closeStream(_ userClose: Bool = false) {
        if let stream = self.outputStream {
            stream.close()
            self.outputStream = nil
        }
        if userClose {
            self.dataDelegate.onClose()
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        self.closeStream()
        print("start")

        var inStream: InputStream? = nil
        var outStream: OutputStream? = nil
        Stream.getBoundStreams(withBufferSize: 4096, inputStream: &inStream, outputStream: &outStream)
        self.outputStream = outStream

        completionHandler(inStream)
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let rawData = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        NSLog("[DATA_ARRIVED] \(rawData)")
        
        for src in (rawData?.split{ $0.isNewline })! {
            NSLog("[DATA_ARRIVED.src]\(src)")
            if src.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                self.dataDelegate.onMessageArrived(message: Message.parse(data: src.data(using: .utf8)!))
            }
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        NSLog("[CLOSE] \(String(describing: error))")
        if error == nil {
            self.dataDelegate.onCompleted()
        } else {
            self.dataDelegate.onError(error: error!)
        }
2
    }
}
