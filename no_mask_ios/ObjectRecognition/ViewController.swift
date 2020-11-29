//
//  ViewController.swift
//  LanguageTutor
//
//  Created by Joshua Newnham on 16/12/2017.
//  Copyright © 2017 Method. All rights reserved.
//

import UIKit
import CoreVideo
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var previewView:CapturePreviewView!
    @IBOutlet var classifiedLabel:UILabel!
    @IBOutlet var adminList:UITextView!
    
    @IBAction func get(_sender : Any) {
        do {
            // URL 설정 GET 방식으로 호출
            let url = URL(string: "http://54.180.165.95:3000/list")
            let response = try String(contentsOf: url!)
            
            // 읽어온 값을 레이블에 표시
            self.adminList.text = response
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    let videoCapture : VideoCapture = VideoCapture()

    let context = CIContext()
    
    let model = MobileNetV2()
//    let model = Inceptionv3()
    
    // 카메라를 초기화 한 후 세션에 할당
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoCapture.delegate = self
        
        if self.videoCapture.initCamera(){
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).session = self.videoCapture.captureSession
            
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            self.videoCapture.asyncStartCapturing()
        } else{
            fatalError("Failed to init VideoCapture")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK: - VideoCaptureDelegate

extension ViewController : VideoCaptureDelegate{
    
    func onFrameCaptured(videoCapture: VideoCapture,
                         pixelBuffer:CVPixelBuffer?,
                         timestamp:CMTime){
        guard let pixelBuffer = pixelBuffer else {return}
        
        guard let scaledPixelBuffer = CIImage(cvImageBuffer: pixelBuffer).resize(size: CGSize(width: 224, height: 224)).toPixelBuffer(context: context) else{return}
        print(scaledPixelBuffer)

        let prediction = try? self.model.prediction(image: scaledPixelBuffer)
        
        DispatchQueue.main.sync {
            classifiedLabel.text = prediction?.classLabel ?? "사물을 인식해주세요"
            print(classifiedLabel ?? "8j")
        }
        
        
    }
}
