//
//  ViewController.swift
//  AVCamera
//
//  Created by Walter Tyree on 3/26/16.
//  Copyright © 2016 Tyree Apps, LLC. All rights reserved.
//

import UIKit
import AVFoundation
import CoreGraphics

class ViewController: UIViewController {

    @IBOutlet weak var captureButton : UIButton!
    var captureSession: AVCaptureSession?
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var photograph = AVCaptureStillImageOutput()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            try device?.lockForConfiguration()
            
            if (device?.isFocusModeSupported(.continuousAutoFocus))! {
                device?.focusMode = AVCaptureFocusMode.continuousAutoFocus
            }
            
            if (device?.isLowLightBoostSupported)! {
                device?.automaticallyEnablesLowLightBoostWhenAvailable = true
            }
            
            if (device?.hasFlash)! && (device?.isFlashAvailable)! {
                device?.flashMode = .auto
            }
            
            if (device?.isExposureModeSupported(.continuousAutoExposure))! {
                device?.exposureMode = .continuousAutoExposure
            } else {
                device?.exposureMode = .autoExpose
            }
            
            if (device?.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance))! {
                device?.whiteBalanceMode = .continuousAutoWhiteBalance
            } else {
                device?.whiteBalanceMode = .autoWhiteBalance
            }
            
            // device.activeVideoMinFrameDuration = CMTimeMake(1, 8)
            device?.unlockForConfiguration()
        } catch let error as NSError {
            print("There was an error changing the framerate \(error.localizedDescription)")
        }
        let input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            print("There was an error creating the input device \(error.localizedDescription)")
            input = nil
        }
        
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        session.addInput(input)
        
        captureDevice = device
        captureSession = session
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {

            previewLayer.frame = self.view.bounds // 
            
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.previewLayer = previewLayer

            
            self.view.layer.addSublayer(self.previewLayer!)
                        self.view.bringSubview(toFront: self.captureButton)
            
            
            
        }
    
    captureSession?.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let preview = self.previewLayer {
            preview.frame = self.view.bounds
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        photograph.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if let capture = self.captureSession {
            
            if capture.canAddOutput(photograph)   {
                capture.addOutput(photograph)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            if let vc = segue.destination as? ImageReviewViewController {
                vc.imageSource = sender as? UIImage
            }
        }
    }
    @IBAction func unwindToCamera(_ sender: UIStoryboardSegue)
    {
        self.captureButton.isEnabled = true
    }
    
    @IBAction func captureCheckImage(_ sender:UIButton?) {
        if let button = sender {
            button.isEnabled = false
        }
        let connection = photograph.connection(withMediaType: AVMediaTypeVideo)
        if connection != nil {
            photograph.captureStillImageAsynchronously(from: connection, completionHandler: { (imageDataBuffer, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer) {
                        
                        
                        var payloadImage = CIImage(data: imageData)!
                        //      CISepiaTone                  CIBloom
                        let sepia = CIFilter(name: "CISepiaTone")
                                                            sepia?.setValue(payloadImage, forKey: "inputImage")
                            payloadImage = sepia!.outputImage!
                        
                        
                        let context = CIContext(options:[kCIContextUseSoftwareRenderer : true])
                        let cgImage = context.createCGImage(payloadImage, from: payloadImage.extent)
                      
                        let convertedImage = UIImage(cgImage: cgImage!)
                        
                        self.performSegue(withIdentifier: "showResult", sender: convertedImage)

                        
                    }
                })
            })
            
        }
        
    }
    
}

