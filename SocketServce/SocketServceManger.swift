//
//  SocketServceManger.swift
//  SocketServce
//
//  Created by 李世洋 on 16/8/7.
//  Copyright © 2016年 李世洋. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

private let HOST = "192.168.1.100"
private let PORT: UInt16 = 5000
private let TIMEOUT: Double = -1

public class SocketServceManger {
    
    var socket: GCDAsyncSocket?
    var clientSockets = [GCDAsyncSocket]()

    init() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
    }
    
    public func openServces() {
        
        do {
            try socket?.acceptOnPort(PORT)
            print("监听成功")
        } catch{
            print(error)
        }
    }
    
    
    static let manger: SocketServceManger = {
        
        return SocketServceManger()
    }()
    
    public class func shareManger() -> SocketServceManger
    {
        return manger
    }

}

extension SocketServceManger: GCDAsyncSocketDelegate
{
    /**
     当有设备连接时调用
     
     - parameter sock:      当前的 Socket 对象
     - parameter newSocket: 主动连接的 Socket 对象
     */
    @objc public func socket(sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        
        print("新的设备已接入 \(newSocket)")
        
        clientSockets.append(newSocket)
        newSocket.readDataWithTimeout(-1, tag: 0)
    }
    
    /**
     收到服务器发来的消息
     
     - parameter sock: 当前的 Socket 对象
     - parameter data: 发送的消息
     - parameter tag:  暂时无用
     */
    @objc public func socket(sock: GCDAsyncSocket, didReadData data: NSData, withTag tag: Int) {
        
        let read = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("收到客户端请求 \(read)")
        
        for soc in clientSockets {
            soc.writeData(data, withTimeout: TIMEOUT, tag: 0)
        }
        
        sock.readDataWithTimeout(TIMEOUT, tag: 0)
    }
}