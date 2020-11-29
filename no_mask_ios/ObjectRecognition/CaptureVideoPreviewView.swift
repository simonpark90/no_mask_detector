//
//  CaptureVideoPreviewView.swift
//  LanguageTutor
//
//  Created by Joshua Newnham on 30/11/2017.
//  Copyright © 2017 Josh Newnham. All rights reserved.
//

import AVFoundation
import UIKit

class CapturePreviewView: UIView {
    //뷰를 생성하는 초기에 호출되어 뷰를 인스턴스화 하고 그에 연결할 CALayer를 결정한다.
    override class var layerClass: AnyClass{
        //동영상 프레임을 처리하기 위한 것이다
        return AVCaptureVideoPreviewLayer.self
    }

}

