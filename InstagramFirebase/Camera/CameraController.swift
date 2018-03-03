//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/12/23.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate{
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        setupCaptureSession()
        setupHUD()
        
    }
    let customAnimationPresenter = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupHUD(){
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.trailingAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    @objc func handleCapturePhoto(){
        print("capture photo...")
        
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageVIew.image = previewImage
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
//        let previewImage = UIImage(data: imageData!)
//
//        let containerView = PreviewPhotoContainerView()
//        containerView.previewImageVIew.image = previewImage
//
//        view.addSubview(containerView)
//        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
////        let previewImageView = UIImageView(image: previewImage)
////        view.addSubview(previewImageView)
////        previewImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        print("finish processing photo smaple buffer")
//
//    }
    
    let output = AVCapturePhotoOutput()
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()

        //1.setup input
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("device error")
            return
        }
        do{
            let input =  try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        }catch let err{
            print("can not setup camera input", err)
        }
        
        //2.setup outputs
    
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        //3.setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

