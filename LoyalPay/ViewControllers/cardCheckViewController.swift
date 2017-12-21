//
//  cardCheckViewController.swift
//  LoyalPay
//
//  Created by Mobile Developer on 11/14/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import TesseractOCR

class cardCheckViewController: UIViewController, G8TesseractDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var homeView: UIView!
    
    let captureSession = AVCaptureSession()
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    var frontCamera: Bool = false
    var input: AVCaptureDeviceInput?
    
    
    var cardCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//        frontCamera(frontCamera)
//        if captureDevice != nil {
            beginSession()
//        }
        getUsers()
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginSession() {
        let camera = getDevice(position: .back)
        
        do {
            input = try AVCaptureDeviceInput (device: camera!)
        } catch let error as NSError {
            print(error)
            input = nil
        }
        if (captureSession.canAddInput(input!) == true) {
            captureSession.addInput(input!)
            stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
            if (captureSession.canAddOutput(stillImageOutput) == true) {
                captureSession.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.cameraView.layer.addSublayer(previewLayer!)
                previewLayer?.frame = self.cameraView.layer.bounds
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                captureSession.startRunning()
            }
            
        }
        
    }
    
    //Get the device (Front or Back)
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices: NSArray = AVCaptureDevice.devices() as NSArray;
        for de in devices {
            let deviceConverted = de as! AVCaptureDevice
            if(deviceConverted.position == position){
                return deviceConverted
            }
        }
        return nil
    }
    
//    func frontCamera(_ front: Bool) {
//        let devices = AVCaptureDevice.devices()
//
//        do {
//            try captureSession.removeInput(AVCaptureDeviceInput(device:captureDevice!))
//        } catch {
//            print("error")
//        }
//
//        for device in devices {
//            if ((device as AnyObject).hasMediaType(AVMediaType.video)) {
//                if front {
//                    if (device as AnyObject).position == AVCaptureDevice.Position.front {
//                        captureDevice = device as? AVCaptureDevice
//
//                        do {
//                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
//                        } catch {
//
//                        }
//                        break
//                    }
//                } else {
//                    if (device as AnyObject).position == AVCaptureDevice.Position.back {
//                        captureDevice = device as? AVCaptureDevice
//
//                        do {
//                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
//                        } catch {
//
//                        }
//                        break
//                    }
//                }
//            }
//        }
//    }
    
    @IBAction func scanBtnClicked(_ sender: UIButton) {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
                stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                let image = UIImage(data: imageData!)
                let tesseract:G8Tesseract = G8Tesseract(language: "eng")
                tesseract.delegate = self
                tesseract.charWhitelist = "0123456789"
                tesseract.image = image
                tesseract.recognize()
                self.label.text = tesseract.recognizedText
                print(tesseract.recognizedText)
            })
        }
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
//        homeView.isHidden = false
//        view.isHidden = true
    }
    
    @IBAction func accumulateBtnclicked(_ sender: UIButton) {
        homeView.isHidden = true
        view.isHidden = false
    }
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition Progress \(tesseract.progress) %")
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
    func textProcessing() {
        // Process text of image captured
        DispatchQueue.main.async(execute: {
            let amountViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: show_AmountVC) as! amountViewController
            self.navigationController?.pushViewController(amountViewController, animated: true)
        })
    }
    
    func getUsers() {
        
        //Please insert the code for getting insurance jsondata from dB
        usersJsonParsing()
        
        cardCount = GlobalData.cardArray?.count ?? 0
        
        if (cardCount != 0) {
            
        } else {
            
        }
        
    }
    
    func usersJsonParsing() {
        
        Alamofire.request(GETUSERS_URL) .responseJSON { response in
            if let jsonDict = response.result.value as? [String:Any],
                let resultArray = jsonDict["result"] as? [[String:Any]] {
                
                GlobalData.cardArray = resultArray.flatMap { $0["cardNumber"] as? String }
                GlobalData.nameArray = resultArray.flatMap { $0["fullName"] as? String }
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

