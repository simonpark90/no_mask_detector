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
    @IBOutlet var topStateView:UITextView!
    @IBOutlet var bottomStateView:UILabel!
    @IBOutlet var stateIcon:UIImageView!
    @IBOutlet var adminButton:UIButton!
    
    let videoCapture : VideoCapture = VideoCapture()
    let context = CIContext()
    let model = model_12_19_1220()
//    let model = MobileNetV2()
//         let model = Inceptionv3()
    let loading = NVActivityIndicatorView(frame: CGRect(x: 168.0, y: 717.0, width: 82, height: 82),
                                            type: .ballRotateChase,
                                            color: .black,
                                            padding: 0) // 로딩 아이콘
    
    var gifStatus = false // 로딩 gif 호출 여부
    var ciImage = CIImage() // 캡쳐 이미지
    var responseData = Data() // 서버 응답 데이터
    var soundEffect: AVAudioPlayer? // 오디오 플레이어
    var spinner = UIActivityIndicatorView(style: .large)
        
    /**
     카메라를 초기화 한 후 세션에 할당
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setFonts()
        self.setButton()
        self.view.addSubview(loading) // 로딩 아이콘 준비
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
            print("얼굴 경계 : \(face.bounds)")
            if face.hasLeftEyePosition && face.hasRightEyePosition && face.hasMouthPosition && face.hasFaceAngle
//                (face.rightEyePosition.x - face.leftEyePosition.x > 60 && face.rightEyePosition.x - face.leftEyePosition.x < 140)
                {
                print("왼쪽 눈 : \(face.leftEyePosition)")
                print("오른쪽 눈 : \(face.rightEyePosition)")
                print("입 : \(face.mouthPosition)")
                print("얼굴 : \(face.faceAngle)")
                isFace = true
            }else{
                isFace = false
            }
        }
        return isFace
    }
    
    /**
     서버에 request를 보내면 로딩 화면 시작
     */
    func startWaitForServer() -> UIViewController {
        let child = WaitServerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        return child
    }
    
    /**
     캡쳐를 다시 시작하기 전까지 대기
     */
    func startWaitForCapture() -> UIViewController {
        let child = WaitCaptureViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        return child
    }
    
    /**
     로딩 화면 제거
     */
    func endWaiting(child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
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
            case "correct":
                print("마스크 착용")
                self.detectMaskFace()
            case "incorrect":
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
        
        // 3초동안 일시 중지
        let time = DispatchTime.now() + .seconds(3)
        let waitingCapture = startWaitForCapture()
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.endWaiting(child: waitingCapture)
        }
    }
    
    /**
     마스크 미착용이 확인되었을 때
     */
    func detectUnmaskFace() {
        
        self.videoCapture.captureSession.stopRunning() // 카메라 일시 중지
        let waitingServer = startWaitForServer() // 로딩 화면 띄우기
        self.playAudio(filename: "loading") // 로딩 사운드 재생
        
        // 사용자 사진 서버로 전송
        let uiImage = UIImage(ciImage: ciImage)
        self.sendImage(image: uiImage)
        
        endWaiting(child: waitingServer) // 로딩 화면 제거
        
        // 서버 응답 처리
        let json = JSON(responseData)
        let result = json["result"].stringValue
//        let result = "false"
        var text = "마스크를 착용해주세요"
        
        // 누군지 인식 되었을 경우 이름과 벌점 저장 후 topStateView에 띄움
        if result == "true" {
            let userName = json["username"].stringValue
            let userCount = json["count"].stringValue
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
        
        // 5초동안 일시 중지
        let time = DispatchTime.now() + .seconds(5)
        let waitingCapture = startWaitForCapture()
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.endWaiting(child: waitingCapture)
            self.videoCapture.captureSession.startRunning()
        }
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
        var alertTitle = "에러 발생"
        var alertMessage = "관리자 호출에 실패하였습니다"
        var done = false // 동기 제어
        var response = "false"
        
        self.playAudio(filename: "buttonPush") // 버튼 클릭 효과음 재생
        self.videoCapture.captureSession.stopRunning() // 카메라 일시 중지
        
        // 관리자 호출 실행 확인 팝업 생성
        let adminCallAlert = UIAlertController(title: "알림", message: "관리자를 호출하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
       
        // "네" 버튼을 누를시 관리자 호출 시도
        adminCallAlert.addAction(UIAlertAction(title: "네", style: UIAlertAction.Style.destructive, handler: { action in
            
            self.playAudio(filename: "buttonPush") // 버튼 클릭 효과음 재생
            
            // 관리자 호출 요청을 서버에 보내고 응답이 올때까지 대기 (동기)
            DispatchQueue.global().sync {
                response = self.sendCallAdminSign()
            }
                        
            // 관리자 호출이 정상적으로 이루어졌을 경우
            if response == "true" {
                alertTitle = "관리자 호출 완료"
                alertMessage = "잠시만 기다려주세요"
            }
            
            // 관리자 호출 결과를 팝업으로 보여줌
            let resGetAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
            resGetAlert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: { action in
                self.playAudio(filename: "buttonPush") // 버튼 클릭 효과음 재생
                done = true
            }))
            self.present(resGetAlert, animated: true, completion: nil)
        }))
        
        // 관리자 호출 취소 버튼 누르면 팝업 사라짐
        adminCallAlert.addAction(UIAlertAction(title: "아니오", style: UIAlertAction.Style.cancel, handler: { action in
            self.playAudio(filename: "buttonPush") // 버튼 클릭 효과음 재생
            done = true
        }))
        self.present(adminCallAlert, animated: true, completion: nil)
        
        // 통신이 끝나고 응답을 받기까지 기다림
        repeat {
               RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        // 3초동안 일시 중지
        let time = DispatchTime.now() + .seconds(3)
        let waitingCapture = startWaitForCapture()
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.endWaiting(child: waitingCapture)
            self.videoCapture.captureSession.startRunning()
        }

    }
    
    /**
     server에 관리자 호출 GET 방식 신호 전송
     return 값 : true, false
     */
    func sendCallAdminSign() -> String {
        
        do {
            let url = URL(string: "http://54.180.165.95:8082/call")
            let response = try String(contentsOf: url!, encoding: .utf8)
            print("응답 결과 : " + response)
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
        guard let jpgData = image.jpegData(compressionQuality: 1.0) else { return }
        let url = URL(string: "http://54.180.165.95:8082/nomask")!
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        var done = false // 동기 제어
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createBody(key: "tempFace",
                                      boundary: boundary,
                                      data: jpgData,
                                      mimeType: "image/jpeg")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print ("이미지 전송 에러 : \(error)")
                done = true
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("이미지 전송 서버 에러")
                done = true
                return
            }
            
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("응답 결과 : \(dataString)")
                self.responseData = data
                done = true
            }
        }
        
        task.resume()
        
        // 통신이 끝나고 응답을 받기까지 기다림
        repeat {
               RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    /**
     이미지 POST 방식으로 전송 시 request body 생성
     */
    private func createBody(key: String,
                            boundary: String,
                            data: Data,
                            mimeType: String) -> Data {
        var body = Data()
        let boundaryPrefix = "\r\n--\(boundary)\r\n"
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
                    
        return body as Data
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
        
        let prediction = try? self.model.prediction(input_1: scaledPixelBuffer)
        
        DispatchQueue.main.sync {
//            classifiedLabel.text = prediction?.classLabel ?? "사물을 인식해주세요"
            print(prediction?.classLabel)
            self.tryClassifyMask(text: prediction?.classLabel ?? "not detected")
//            self.tryClassifyMask(text: "not wearing a mask")
//            self.tryClassifyMask(text: "wearing a mask")
            // self.tryClassifyMask(text: "default state")
//             print(classifiedLabel ?? "8j")
            
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
