//
//  CameraVC+AVCapturePhotoCaptureDelegate.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 25.03.2024.
//

import UIKit
import AVFoundation

// MARK: AVCapturePhotoCaptureDelegate
extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print(error?.localizedDescription)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        if let image = UIImage(data: imageData) {
            print("Сделал фото")
            self.imageView.image = image
            delegateOfCamera?.setPhoto(photo: image)
        }
    }

}
