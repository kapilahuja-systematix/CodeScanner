//
//  QRScan.swift
//  QRScanner
//
//  Created by Mac mini on 02/11/16.
//  Copyright © 2016 SIPL. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

@objc protocol CodeScanDelegate {
    @objc optional func CodeScanSuccedd(Code: String)
    @objc optional func CodeScanFail(ErrorMessage: String)
}

class CodeScan: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var mainView: UIView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let sharedInstance = CodeScan()
    var codeScanDelegate: CodeScanDelegate?
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var captureMetadataOutput:AVCaptureMetadataOutput?
    
    let supportedCodeTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypePDF417Code]

    
    func ScanCode() {
        
        mainView = UIView()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        mainView.frame = UIScreen.main.bounds
        
        let button:UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        button.setTitle(" X ", for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.CrossClicked), for: .touchUpInside)
        mainView.addSubview(button)
        
        //  4.
        let topEdgeConstraint = NSLayoutConstraint(item: button,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: mainView,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: 20.0)
        
        let leadingConstraint = NSLayoutConstraint(item: button,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: mainView,
                                                   attribute: .leading,
                                                   multiplier: 1.0,
                                                   constant: 20.0)
        
        mainView.addConstraints([topEdgeConstraint,leadingConstraint])
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput?.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = UIScreen.main.bounds
            mainView.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                mainView.addSubview(qrCodeFrameView)
                mainView.bringSubview(toFront: qrCodeFrameView)
            }
            
            mainView.bringSubview(toFront: button)
            appDelegate.window?.rootViewController?.view.addSubview(mainView)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            codeScanDelegate?.CodeScanFail?(ErrorMessage: error.localizedDescription)
            CloseSession()
            return
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            // No QR code is detected
            qrCodeFrameView?.frame = CGRect.zero
            CloseSession()
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                codeScanDelegate?.CodeScanSuccedd?(Code: metadataObj.stringValue)
                captureMetadataOutput?.setMetadataObjectsDelegate(nil, queue: DispatchQueue.main)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // your code here
                self.CloseSession()
            }
        }
    }
    
    func CrossClicked() {
        codeScanDelegate?.CodeScanFail?(ErrorMessage: "Cancel Clicked")
        CloseSession()
    }
    
    func CloseSession(){
        mainView.removeFromSuperview()
        captureSession = nil
        captureMetadataOutput = nil
        mainView = nil        
    }
}
