//
//  ViewController.swift
//  moon
//
//  Created by Rika Horiguchi on 2015/09/05.
//  Copyright (c) 2015年 RFP. All rights reserved.
//

import UIKit
import AVFoundation
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    
    var socket = WebSocket(url: NSURL(scheme: "ws", host: "192.168.100.101:8080", path: "/moon/flush")!)
    
    //var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8887", path: "/moon/flush")!, protocols: ["chat", "superchat"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景色をCyanに設定する.
        self.view.backgroundColor = UIColor.cyanColor()
        
        // Swicthを作成する.
        let mySwicth: UISwitch = UISwitch()
        mySwicth.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 200)
        
        // Swicthの枠線を表示する.
        mySwicth.tintColor = UIColor.blackColor()
        
        // SwitchをOnに設定する.
        mySwicth.on = true
        
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
        mySwicth.addTarget(self, action: "onClickMySwicth:", forControlEvents: UIControlEvents.ValueChanged)
        
        // SwitchをViewに追加する.
        self.view.addSubview(mySwicth)
        
        // On/Offを表示するラベルを作成する.
        myLabel = UILabel(frame: CGRectMake(0,0,150,150))
        myLabel.backgroundColor = UIColor.orangeColor()
        myLabel.layer.masksToBounds = true
        myLabel.layer.cornerRadius = 75.0
        myLabel.textColor = UIColor.whiteColor()
        myLabel.shadowColor = UIColor.grayColor()
        myLabel.font = UIFont.systemFontOfSize(CGFloat(30))
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
        myLabel.text = "On"
        
        // ラベルをviewに追加
        self.view.addSubview(myLabel)
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
        try device.lockForConfiguration()
        device.torchMode = AVCaptureTorchMode.On //Off
        device.unlockForConfiguration()
        
        try device.lockForConfiguration()
        device.torchMode = AVCaptureTorchMode.Off //On
        device.unlockForConfiguration()
        } catch {
        
        }
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(sender: UIBarButtonItem) {
        socket.writeString("hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(sender: UIBarButtonItem) {
        if socket.isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
    
    
    private var myLabel: UILabel!
    
    
    
    //    internal func onClickMySwicth(sender: UISwitch){
    //
    //        if sender.on {
    //            myLabel.text = "On"
    //            myLabel.backgroundColor = UIColor.orangeColor()
    //            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    //            device.lockForConfiguration(nil)
    //            device.torchMode = AVCaptureTorchMode.Off //On
    //            device.unlockForConfiguration()
    //        }
    //        else {
    //            myLabel.text = "Off"
    //            myLabel.backgroundColor = UIColor.grayColor()
    //            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    //            device.lockForConfiguration(nil)
    //            device.torchMode = AVCaptureTorchMode.On //Off
    //            device.unlockForConfiguration()
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

