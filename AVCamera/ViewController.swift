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
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            try device.lockForConfiguration()
            
            if device.isFocusModeSupported(.ContinuousAutoFocus) {
                device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
            }
            
            if device.hasFlash && device.flashAvailable {
                device.flashMode = .Auto
            }
            
            if device.isExposureModeSupported(.ContinuousAutoExposure) {
                device.exposureMode = .ContinuousAutoExposure
            } else {
                device.exposureMode = .AutoExpose
            }
            
            if device.isWhiteBalanceModeSupported(.ContinuousAutoWhiteBalance) {
                device.whiteBalanceMode = .ContinuousAutoWhiteBalance
            } else {
                device.whiteBalanceMode = .AutoWhiteBalance
            }
            
            // device.activeVideoMinFrameDuration = CMTimeMake(1, 8)
            device.unlockForConfiguration()
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
                        self.view.bringSubviewToFront(self.captureButton)
            
            
            //       previewView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        photograph.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if let capture = self.captureSession {
            
            if capture.canAddOutput(photograph)   {
                capture.addOutput(photograph)
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showResult" {
            if let vc = segue.destinationViewController as? ImageReviewViewController {
                vc.imageSource = sender as? UIImage
            }
        }
    }
    @IBAction func unwindToCamera(sender: UIStoryboardSegue)
    {
        self.captureButton.enabled = true
    }
    
    @IBAction func captureCheckImage(sender:UIButton?) {
        if let button = sender {
            button.enabled = false
        }
        let connection = photograph.connectionWithMediaType(AVMediaTypeVideo)
        if connection != nil {
            photograph.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataBuffer, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer) {
                        
                        
                        var payloadImage = CIImage(data: imageData)!
                        //      CISepiaTone                  CIBloom
                        let sepia = CIFilter(name: "CISepiaTone")
                                                            sepia?.setValue(payloadImage, forKey: "inputImage")
                            payloadImage = sepia!.outputImage!
                        
                        
                        let context = CIContext(options:[kCIContextUseSoftwareRenderer : true])
                        let cgImage = context.createCGImage(payloadImage, fromRect: payloadImage.extent)
                      
                        let convertedImage = UIImage(CGImage: cgImage)
                        
                        self.performSegueWithIdentifier("showResult", sender: convertedImage)

                        
                    }
                })
            })
            
        }
        
    }
    
}

