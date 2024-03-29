//
//  FotoViewController.swift
//  makeAndShare
//
//  Created by Кирилл Лукьянов on 17/06/2019.
//  Copyright © 2019 Кирилл Лукьянов. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController {
    
    var onTakePicture: ((UIImage) -> Void)?
    var captureSession: AVCaptureSession?
    var cameraOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var deviceOrientationOnCapture: UIDeviceOrientation?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        previewLayer?.frame = view.layer.bounds
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
  
        if previewLayer?.connection?.isVideoOrientationSupported == true {
            previewLayer?.connection?.videoOrientation = UIDevice.current.orientation.getAVCaptureVideoOrientationFromDevice()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cameraOutput = makeCameraOutput()
        self.cameraOutput = cameraOutput
        guard let captureSession = makeCameraSession(cameraOutput: cameraOutput) else { return }
        self.captureSession = captureSession
        configurePreviewLayer(captureSession, cameraOutput)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    @IBAction func takePicture(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        cameraOutput?.capturePhoto(with: settings, delegate: self)

    }
    
    func cameraDeviceFind() -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .front
        )
        let devices = discoverySession.devices
        let device = devices
            .first(where: { $0.hasMediaType(AVMediaType.video) && $0.position == .front })
        return device
    }
    
    func makeCameraOutput() -> AVCapturePhotoOutput {
        let cameraOutput = AVCapturePhotoOutput()
        cameraOutput.isHighResolutionCaptureEnabled = true
        cameraOutput.isLivePhotoCaptureEnabled = false
        return cameraOutput
    }
    
    func makeCameraSession(cameraOutput: AVCapturePhotoOutput) -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        
        guard
            let device = cameraDeviceFind(),
            let input = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(input) else {
                return nil
        }
        captureSession.addInput(input)
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureSession.addOutput(cameraOutput)
        
        return captureSession
    }
    
    func configurePreviewLayer(_ captureSession: AVCaptureSession, _ cameraOutput: AVCapturePhotoOutput) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.layer.bounds
        self.previewLayer = previewLayer
    }
    
}

extension PhotoViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard
            let imageData = photo.fileDataRepresentation(),
            let uiImage = UIImage(data: imageData),
            let cgImage = uiImage.cgImage,
            let deviceOrientationOnCapture = self.deviceOrientationOnCapture else {
                return
                
        }
        let image = UIImage(
            cgImage: cgImage,
            scale: 1.0,
            orientation: deviceOrientationOnCapture.getUIImageOrientationFromDevice()
        )
        onTakePicture?(image)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        deviceOrientationOnCapture = UIDevice.current.orientation
    }
}

fileprivate extension UIDeviceOrientation {
    func getUIImageOrientationFromDevice() -> UIImage.Orientation {
        let orientation: UIImage.Orientation
        switch self {
        case .portrait,
             .faceUp:
            orientation = .right
        case .portraitUpsideDown,
             .faceDown:
            orientation = .left
        case .landscapeLeft:
            orientation = .down
        case .landscapeRight:
            orientation = .up
        case .unknown:
            orientation = .down
        }
        return orientation
    }
    
    func getAVCaptureVideoOrientationFromDevice() -> AVCaptureVideoOrientation {
        let orientation: AVCaptureVideoOrientation
        switch self {
        case .portrait,
             .faceUp:
            orientation = .portrait
        case .portraitUpsideDown,
             .faceDown:
            orientation = .portraitUpsideDown
        case .landscapeLeft:
            orientation = .landscapeRight
        case .landscapeRight:
            orientation = .landscapeLeft
        case .unknown:
            orientation = .landscapeLeft
        }
        return orientation
    }
    
}
