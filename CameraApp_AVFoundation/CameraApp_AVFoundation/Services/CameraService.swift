//
//  CameraService.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 20.03.2024.
//

import Foundation
import AVFoundation

protocol CameraServiceProtocol {
    var cameraSession: AVCaptureSession { get set }
    var output: AVCapturePhotoOutput { get set }
    
    func setupCaptureSession()
    func stopSession()
    func switchCamera()
}

final class CameraService: CameraServiceProtocol {
    
    private var captureDevice: AVCaptureDevice?
    private let cameraQueue = DispatchQueue(label: "camera.queue")
    
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    
    private var backInput: AVCaptureDeviceInput!
    private var frontInput: AVCaptureDeviceInput!
    
    private var isBackCamera = true
    
    var cameraSession: AVCaptureSession = AVCaptureSession()
    var output: AVCapturePhotoOutput = AVCapturePhotoOutput()
    
    func setupCaptureSession() {
        cameraQueue.async { [weak self] in
            self?.cameraSession.beginConfiguration()
            if let isSetPreset = self?.cameraSession.canSetSessionPreset(.photo) {
                self?.cameraSession.sessionPreset = .photo
            }
            
            self?.setInputs()
            self?.setOutputs()
            
            self?.cameraSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self?.cameraSession.commitConfiguration()
            
            self?.cameraSession.startRunning()
            
        }
        
    }
    
    func setInputs() {
        backCamera = getCurrentDevice()
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        guard let backCamera = backCamera, let frontCamera = frontCamera else { return }
        
        do {
            backInput = try AVCaptureDeviceInput(device: backCamera)
            guard cameraSession.canAddInput(backInput) else { return }
            
            frontInput = try AVCaptureDeviceInput(device: frontCamera)
            guard cameraSession.canAddInput(frontInput) else { return }
            
            cameraSession.addInput(backInput)
            captureDevice = backCamera
        } catch {
            print("setInputs error")
        }
        
    }
    
    func setOutputs() {
        guard cameraSession.canAddOutput(output) else { return }
        output.maxPhotoQualityPrioritization = .balanced
        cameraSession.addOutput(output)
    }
    
    func stopSession() {
        cameraSession.stopRunning()
        cameraSession.removeInput(backInput)
        cameraSession.removeInput(frontInput)
        isBackCamera = true
    }
    
    func switchCamera() {
        cameraSession.beginConfiguration()
        if isBackCamera {
            cameraSession.removeInput(backInput)
            cameraSession.addInput(frontInput)
            captureDevice = frontCamera
            isBackCamera = false
        } else {
            cameraSession.removeInput(frontInput)
            cameraSession.addInput(backInput)
            captureDevice = backCamera
            isBackCamera = true
        }
        cameraSession.commitConfiguration()
    }
    
    func getCurrentDevice() -> AVCaptureDevice? {
        let sessionDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTripleCamera,
                                                                           .builtInDualCamera,
                                                                           .builtInWideAngleCamera,
                                                                           .builtInDualWideCamera
                                                                            ], mediaType: .video, position: .back)
        guard let device = sessionDevice.devices.first else { return nil }
        return device
    }
    
}
