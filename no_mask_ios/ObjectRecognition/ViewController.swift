//
//  ViewController.swift
//  LanguageTutor
//
//  Created by Joshua Newnham on 16/12/2017.
//  Copyright © 2017 Method. All rights reserved.
//

import UIKit
import CoreVideo
import CoreImage
import AVFoundation
import SwiftyJSON
import AudioToolbox
import NVActivityIndicatorView

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
    let loading = NVActivityIndicatorView(frame: CGRect(x: 168.0, y: 717.0, width: 82, height: 82),
                                            type: .ballRotateChase,
                                            color: .black,
                                            padding: 0) // 로딩 아이콘
    
    var gifStatus = false // 로딩 gif 호출 여부
    var ciImage = CIImage() // 캡쳐 이미지
    var responseData = Data() // 서버 응답 데이터
    var soundEffect: AVAudioPlayer? // 오디오 플레이어
        
    /**
     카메라를 초기화 한 후 세션에 할당
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.get()
        self.setFonts()
        self.setButton()
        self.view.addSubview(loading)
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
    
    /**
     세로모드 고정
     */
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    /**
     초기 폰트 설정
     */
    func setFonts() {
        topStateView.font = UIFont(name: "NanumSquareOTFEB", size: 23)
        bottomStateView.font = UIFont(name: "NanumSquareOTFEB", size: 23)
    }
    
    /**
     관리자 버튼 초기 설정
     */
    func setButton() {
        adminButton.layer.cornerRadius = 20
        adminButton.layer.shadowColor = UIColor.gray.cgColor
        adminButton.layer.shadowOpacity = 1.0
        adminButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        adminButton.layer.shadowRadius = 1.0
    }
    
    /**
     사람 얼굴 인식
     */
    func checkFaceDetection(image: CIImage) -> Bool {
        var isFace = false
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: image)

        if let face = faces?.first as? CIFaceFeature {
            print("Found face at \(face.bounds)")
            if face.hasLeftEyePosition && face.hasRightEyePosition && face.hasMouthPosition && face.hasFaceAngle{
                isFace = true
            }else{
                isFace = false
            }
        }
        return isFace
    }
    
    /**
     마스크 착용 판별
     */
    func tryClassifyMask(text: String) {
        // 사람얼굴이 있을때만 판별
        if checkFaceDetection(image: ciImage) == false {
            self.mainScreen()
        } else {
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
    }
    
    /**
     Default 화면
     */
    func mainScreen() {
        // topStateView 세팅
        topStateView.text = "마스크 착용 감지 시스템입니다\n얼굴을 가까이 해주세요"
        topStateView.textColor = UIColor.black
        
        // bottomStateView 세팅
        bottomStateView.text = "잠시만 기다려 주세요"
        bottomStateView.textColor = UIColor.black
        
        // Icon 세팅 : Default 화면에서 최초 1번만 로딩아이콘 띄움
        if self.gifStatus == false {
            stateIcon.image = UIImage()
            loading.startAnimating()
            self.gifStatus = true
        }
    }
    
    /**
     마스크 착용이 확인되었을 때
     */
    func detectMaskFace() {
        let customGreen = #colorLiteral(red: 0.3058823529, green: 0.7019607843, blue: 0.6196078431, alpha: 1)
        
        // topStateView 세팅
        topStateView.text = "마스크 착용이 확인되었습니다"
        topStateView.textColor = customGreen
        topStateView.centerVertically()
        
        // bottomStateView 세팅
        bottomStateView.text = "감사합니다"
        bottomStateView.textColor = customGreen
        
        // Icon 세팅 : loading 아이콘 제거
        if gifStatus == true {
            loading.stopAnimating()
            self.gifStatus = false
        }
        stateIcon.image = UIImage(named: "checked.png")
        
        // 통과 사운드 재생
        self.playAudio(filename: "pass")
        
    }
    
    /**
     마스크 미착용이 확인되었을 때
     */
    func detectUnmaskFace() {
        // 사용자 사진 서버로 전송
        bottomStateView.text = "인식중..."
        let uiImage = UIImage(ciImage: ciImage)
        self.sendImage(image: uiImage)
        
        // 서버 응답 처리
        let json = JSON(responseData)
//        let result = json["result"].stringValue
        let result = "false"
        var text = "마스크를 착용해주세요"
        
        // 누군지 인식 되었을 경우 이름과 벌점 저장 후 topStateView에 띄움
        if result == "true" {
            let userName = json["userName"].stringValue
            let userCount = json["userCount"].stringValue
            text = "\(userName)님 마스크를 착용해주세요\n누적벌점 \(userCount)점"
        }

        // topStateView 세팅
        topStateView.text = text
        topStateView.textColor = UIColor.systemRed
        topStateView.centerVertically()
        
        // bottomStateView 세팅
        bottomStateView.text = "입장 불가"
        bottomStateView.textColor = UIColor.systemRed
        
        // Icon 세팅 : loading 아이콘 제거
        if gifStatus == true {
            loading.stopAnimating()
            self.gifStatus = false
        }
        stateIcon.image = UIImage(named: "prohibition.png")
        
        // 경고 사운드 재생
        self.playAudio(filename: "alart")
        
    }
    
    /**
     효과음 재생
     */
    func playAudio(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: "mp3")
    
        if let url = url {
            do {
                soundEffect = try AVAudioPlayer(contentsOf: url)
                guard let sound = soundEffect else { return }
                sound.play()
            } catch let error {
                print("효과음 재생 오류 : " + error.localizedDescription)
            }
        }
    }
    
    /**
     관리자 호출 버튼 클릭시 실행
     */
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
    
    /**
     server에 관리자 호출 GET 방식 신호 전송
     return 값 : true, false
     */
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
    
    /**
     이미지 POST 방식 전송
     return 값 : JSON data
     */
    func sendImage(image: UIImage) {
        let jpgData = image.jpegData(compressionQuality: 1.0)
        let url = URL(string: "http://54.180.165.95:3000/send")!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.setValue(formatter.string(from: Date()), forHTTPHeaderField: "Date")
                                 
        let task = URLSession.shared.uploadTask(with: request, from: jpgData) { data, response, error in
            if let error = error {
                print ("이미지 전송 에러 : \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("이미지 전송 서버 에러")
                return
            }
            
            if let mimeType = response.mimeType,
                mimeType == "image/jpeg",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("응답 결과 : \(dataString)")
                self.responseData = data
            }
        }
        task.resume()
    }
    
    /**
     test
     */
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
        
        ciImage = CIImage(cvImageBuffer: pixelBuffer)
        guard let scaledPixelBuffer = ciImage.resize(size: CGSize(width: 224, height: 224)).toPixelBuffer(context: context) else{return}
        //print(scaledPixelBuffer)
        
        let prediction = try? self.model.prediction(image: scaledPixelBuffer)
        
        DispatchQueue.main.sync {
            classifiedLabel.text = prediction?.classLabel ?? "사물을 인식해주세요"
            //self.tryClassifyMask(text: prediction?.classLabel ?? "not detected")
            self.tryClassifyMask(text: "not wearing a mask")
//            self.tryClassifyMask(text: "wearing a mask")
            // self.tryClassifyMask(text: "default state")
            // print(classifiedLabel ?? "8j")
            
        }
        
        
    }
}

// MARK: - UITextView

extension UITextView {
    
    /**
     textview 수직 가운데 정렬
     */
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
            contentOffset.y = -positiveTopOffset
     }
}
