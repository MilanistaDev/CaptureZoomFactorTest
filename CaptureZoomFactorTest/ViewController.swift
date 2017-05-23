//
//  ViewController.swift
//  CaptureZoomFactorTest
//
//  Created by 麻生 拓弥 on 2017/05/23.
//  Copyright © 2017年 麻生 拓弥. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var currentScaleLabel: UILabel!
    @IBOutlet weak var zoomMaxScaleLabel: UILabel!

    var captureDevice: AVCaptureDevice!

    override func viewDidLoad() {
        super.viewDidLoad()

        let devices = AVCaptureDevice.devices()
        for device in devices! {
            // Acquire 'Back Camera' / 背面カメラを取得
            if (device as AnyObject).position == AVCaptureDevicePosition.back {
                self.captureDevice = device as! AVCaptureDevice
            }
        }
        // Display current videoZoomFactor value / 現在の videoZoomFactor の値を表示
        self.currentScaleLabel.text = "current: " + self.captureDevice.videoZoomFactor.description
        self.zoomMaxScaleLabel.text = "videoMaxZoomFactor: " + self.captureDevice.activeFormat.videoMaxZoomFactor.description
    }

    /**
      Bad Pattern / よくない場合
      App crash for iPhone 4S / iPhone 4S などで落ちる
      Set a value greater than 1.0. Really? /
      iPhone 4S などの videoMaxZoomFactor は 1.0 なのにそれ以上をセット？
    */
    @IBAction func badPatternAction(_ sender: Any) {
        do {
            try self.captureDevice.lockForConfiguration()
        } catch {
            // When error occurred
            return
        }
        self.captureDevice.videoZoomFactor = 2.0 // Some devices crash here... / 端末によってはここでクラッシュ
        self.currentScaleLabel.text = "current: " + self.captureDevice.videoZoomFactor.description

        self.captureDevice.unlockForConfiguration()
    }

    /**
      Better pattern / 少なくともこの場合で
      If videoMaxZoomFactor value is 1.0, set 1.0. /
      videoMaxZoomFactor が 1.0 の場合は 1.0 を代入する(諦める)
    */
    @IBAction func betterPatternAction(_ sender: Any) {

        do {
            try self.captureDevice.lockForConfiguration()
        } catch {
            // When error occurred
            return
        }
        // If videoMaxZoomFactor is 1.0, substitute 1.0. Otherwise substitute 2.0.
        // videoMaxZoomFactor が 1.0 の場合は 1.0 を代入，それ以外は2.0をセット
        self.captureDevice.videoZoomFactor = (self.captureDevice.activeFormat.videoMaxZoomFactor == 1.0) ? 1.0 : 2.0
        self.currentScaleLabel.text = "current: " + self.captureDevice.videoZoomFactor.description

        self.captureDevice.unlockForConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

