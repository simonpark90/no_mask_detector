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
    @IBOutlet var topStateView:UITextView!
    @IBOutlet var bottomStateView:UILabel!
    @IBOutlet var stateIcon:UIImageView!
    @IBOutlet var adminButton:UIButton!
    
    let videoCapture : VideoCapture = VideoCapture()
    let context = CIContext()
    let model = MobileNetV2()
    //    let model = Inceptionv3()
    var gifStatus = false // 로딩 gif 호출 여부
    let loadingGif = UIImage.gifImageWithName("loadAnim") // 로딩 gif 파일
        
    // 카메라를 초기화 한 후 세션에 할당
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.get()
        self.setFonts()
        self.setButton()
        self.videoCapture.delegate = self
        self.gifStatus = false
        
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
    
    // 세로모드 고정
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // 관리자 호출 버튼 클릭시 실행
    @IBAction func onClick(sender: AnyObject) {
        print("버튼 클릭")
        
        // 관리자 호출 실행 확인 팝업 생성
        let adminCallAlert = UIAlertController(title: "알림", message: "관리자를 호출하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        adminCallAlert.addAction(UIAlertAction(title: "네", style: UIAlertAction.Style.destructive, handler: { action in
            
            let response = self.sendCallAdminSign() // "네" 버튼을 누를시 실행
            var alertTitle = "에러 발생"
            var alertMessage = "관리자 호출에 실패하였습니다"
            
            if response == "true" {
                alertTitle = "관리자 호출 완료"
                alertMessage = "잠시만 기다려주세요"
            }
            
            let resGetAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
            resGetAlert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(resGetAlert, animated: true, completion: nil)
        }))
        
        adminCallAlert.addAction(UIAlertAction(title: "아니오", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(adminCallAlert, animated: true, completion: nil)
    }
    
    // 초기 폰트 설정
    func setFonts() {
        topStateView.font = UIFont(name: "NanumSquareOTFEB", size: 23)
        bottomStateView.font = UIFont(name: "NanumSquareOTFEB", size: 23)
    }
    
    // 관리자 버튼 초기 설정
    func setButton() {
        adminButton.layer.cornerRadius = 20
        adminButton.layer.shadowColor = UIColor.gray.cgColor
        adminButton.layer.shadowOpacity = 1.0
        adminButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        adminButton.layer.shadowRadius = 1.0
    }
    
    // server에 관리자 호출 GET 방식 신호 전송
    // return 값 : true, false
    func sendCallAdminSign() -> String {
        do {
            let url = URL(string: "http://54.180.165.95:3000/call")
            let response = try String(contentsOf: url!)
            return response
            
        } catch let e as NSError {
            print(e.localizedDescription)
            return "false"
        }
    }
    
    // 마스크 착용 판별
    func tryClassifyMask(text: String) {
        switch text {
        case "wearing a mask":
            print("마스크 착용")
            self.detectMaskFace()
        case "not wearing a mask":
            print("마스크 미착용")
            self.detectUnmaskFace()
        default:
            print("얼굴 감지중")
            self.mainScreen()
        }
    }
    
    // Default 화면
    func mainScreen() {
        // topStateView 세팅
        topStateView.text = "마스크 착용 감지 시스템입니다\n얼굴을 가까이 해주세요"
        topStateView.textColor = UIColor.black
        
        // bottomStateView 세팅
        bottomStateView.text = "잠시만 기다려 주세요"
        bottomStateView.textColor = UIColor.black
        
        // Icon 세팅 : Default 화면에서 최초 1번만 로딩화면 띄움
        if self.gifStatus == false {
            let stateIcon = UIImageView(image: loadingGif)
            stateIcon.frame = CGRect(x: 168.0, y: 717.0, width: 82, height: 82)
            view.addSubview(stateIcon)
            self.gifStatus = true
        }
    }
    
    // 마스크 착용이 확인되었을 때
    func detectMaskFace() {
        let customGreen = #colorLiteral(red: 0.3058823529, green: 0.7019607843, blue: 0.6196078431, alpha: 1)
        
        // topStateView 세팅
        topStateView.text = "마스크 착용이 확인되었습니다"
        topStateView.textColor = customGreen
        topStateView.centerVertically()
        
        // bottomStateView 세팅
        bottomStateView.text = "감사합니다"
        bottomStateView.textColor = customGreen
        
        // Icon 세팅 : loading gif 제거
        if gifStatus == true {
            stateIcon.removeFromSuperview()
            self.gifStatus = false
        }
        stateIcon.image = UIImage(named: "checked.png")
    }
    
    // 마스크 미착용이 확인되었을 때
    func detectUnmaskFace() {
        // topStateView 세팅
        topStateView.text = "마스크를 착용해주세요"
        topStateView.textColor = UIColor.systemRed
        topStateView.centerVertically()
        
        // bottomStateView 세팅
        bottomStateView.text = "입장 불가"
        bottomStateView.textColor = UIColor.systemRed
        
        // Icon 세팅 : loading gif 제거
        if gifStatus == true {
            stateIcon.removeFromSuperview()
            self.gifStatus = false
        }
        stateIcon.image = UIImage(named: "prohibition.png")
    }
    
    func get() {
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
}
// MARK: - VideoCaptureDelegate

extension ViewController : VideoCaptureDelegate{
    
    func onFrameCaptured(videoCapture: VideoCapture,
                         pixelBuffer:CVPixelBuffer?,
                         timestamp:CMTime){
        guard let pixelBuffer = pixelBuffer else {return}
        
        guard let scaledPixelBuffer = CIImage(cvImageBuffer: pixelBuffer).resize(size: CGSize(width: 224, height: 224)).toPixelBuffer(context: context) else{return}
        //print(scaledPixelBuffer)

        let prediction = try? self.model.prediction(image: scaledPixelBuffer)
        
        DispatchQueue.main.sync {
            classifiedLabel.text = prediction?.classLabel ?? "사물을 인식해주세요"
            //self.tryClassifyMask(text: prediction?.classLabel ?? "not detected")
            // self.tryClassifyMask(text: "not wearing a mask")
            // self.tryClassifyMask(text: "wearing a mask")
            self.tryClassifyMask(text: "default state")
            // print(classifiedLabel ?? "8j")
        }
        
        
    }
}

// MARK: - UITextView

extension UITextView {
    
    // textview 수직 가운데 정렬
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
            contentOffset.y = -positiveTopOffset
     }
}
