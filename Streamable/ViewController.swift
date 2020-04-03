//
//  ViewController.swift
//  Streamable
//
//  Created by Nick Shields on 2020-04-02.
//  Copyright © 2020 Nick Shields. All rights reserved.
//

import UIKit
import HaishinKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudio()
        self.rtmp_publish_stream()
        // Do any additional setup after loading the view.
    }
    
    func setupAudio(){
        print("In here")
        let session = AVAudioSession.sharedInstance()
        do{
            if #available(iOS 10.0, *){
                print("This is what I did")
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            }else{
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord,
                                with: [AVAudioSession.CategoryOptions.allowBluetooth, AVAudioSession.CategoryOptions.defaultToSpeaker])
                try session.setMode(.default)
            }
            try session.setActive(true)
        }catch{
            print(error)
        }
    }
    
    func rtmp_publish_stream(){
        let rtmpConnection = RTMPConnection()
        let rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio)) { error in
            print(error)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .back)) { error in
            print("SHIT")
            print(error)
        }
        
        let hkView = HKView(frame: view.bounds)
        hkView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        hkView.attachStream(rtmpStream)
        
        view.addSubview(hkView)
        
        rtmpConnection.connect("rtmp://192.168.1.11:32782/show")
        rtmpStream.publish("test")
    
    }


}

