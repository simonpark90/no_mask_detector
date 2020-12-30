//
//  waitCaptureViewController.swift
//  ObjectRecognition
//
//  Created by Park JooHyun on 2020/12/17.
//  Copyright © 2020 Method. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

class WaitCaptureViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.0)

        let cellWidth = Int(view.frame.width / 2 - 40)
        let cellHeight = Int(view.frame.height / 2 - 40)
        
        let frame = CGRect(x: cellWidth, y: cellHeight, width: 40, height: 40)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: .lineSpinFadeLoader,
                                                            color: .white,
                                                            padding: 0)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }

}
