//
//  VideoCapture.swift
//  LanguageTutor
//
//  Created by Joshua Newnham on 29/11/2017.
//  Copyright © 2017 Josh Newnham. All rights reserved.
//

import UIKit
import AVFoundation

//fps 유지시켜주기
public protocol VideoCaptureDelegate: class {
    func onFrameCaptured(videoCapture: VideoCapture, pixelBuffer:CVPixelBuffer?, timestamp:CMTime)
}

/**
 Class used to faciliate accessing each frame of the camera using the AVFoundation framework (and presenting
 the frames on a preview view)
 https://developer.apple.com/documentation/avfoundation/avcapturevideodataoutput
 */
public class VideoCapture : NSObject{
    
    public weak var delegate: VideoCaptureDelegate?

    public var fps = 15
    
    //마지막 capture 시간
    var lastTimestamp = CMTime()
    
    
    let captureSession = AVCaptureSession()
    let sessionQueue = DispatchQueue(label : "session queue")
    
    override init() {
        super.init()
        
    }
    
    func initCamera() -> Bool{
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("ERROR : no video devices available")
            return false;
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("ERROR : could not create AVCaptureDeviceInput")
            return false;
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        let settings:[String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        videoOutput.videoSettings = settings
        //디스패치 큐가 사용 중일 떄 도착한 프레임은 모두 폐기
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        if captureSession.canAddOutput(videoOutput){
            captureSession.addOutput(videoOutput)
        }
        videoOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        
        return true
    }
    
    /**
     Start capturing frames
     This is a blocking call which can take some time, therefore you should perform session setup off
     the main queue to avoid blocking it.
     */
    public func asyncStartCapturing(completion: (() -> Void)? = nil){
        sessionQueue.async {
            if !self.captureSession.isRunning{
                self.captureSession.startRunning()
            }
            if let completion = completion{
                DispatchQueue.main.async {
                    completion()
                }
            }
        }

    }
    
    /**
     Stop capturing frames
     */
    public func asyncStopCapturing(completion: (() -> Void)? = nil){
        sessionQueue.async{
            if self.captureSession.isRunning{
                self.captureSession.stopRunning()
            }
            
            if let completion = completion{
                DispatchQueue.main.async{
                    completion()
                }
            }
        }
    }

    
    
}
// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

// AVCaptureVideoDataOutputSampleBufferDelegate - protocol(특정영역에서 사용)
// extension -> AVCaptureVideoDataOutputSampleBufferDelegate에 포함된 함수사용?
extension VideoCapture : AVCaptureVideoDataOutputSampleBufferDelegate{
    
    /**
     Called when a new video frame was written
    */
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let delegate = self.delegate else{ return }

        // Returns the earliest presentation timestamp of all the samples in a CMSampleBuffer
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

        // Throttle capture rate based on assigned fps
        let elapsedTime = timestamp - lastTimestamp
        if elapsedTime >= CMTimeMake(value: 1, timescale: Int32(fps)) {
            // update timestamp
            lastTimestamp = timestamp
            // get sample buffer's CVImageBuffer
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            // pass onto the assigned delegate
            delegate.onFrameCaptured(videoCapture: self,
                                     pixelBuffer:imageBuffer,
                                     timestamp: timestamp)
        }
    }
    
    /**
     Called when a frame is dropped
     */
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Ignore
    }
}
