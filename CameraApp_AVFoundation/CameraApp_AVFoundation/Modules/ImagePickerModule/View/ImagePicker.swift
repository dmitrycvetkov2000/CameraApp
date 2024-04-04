//
//  ImagePicker.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 04.04.2024.
//

import UIKit

class ImagePicker: NSObject {
    var imagePickerVC: UIImagePickerController?
    var completion: ((UIImage) -> ())?
    
    init(imagePickerVC: UIImagePickerController? = nil) {
        self.imagePickerVC = imagePickerVC
        super.init()
        self.imagePickerVC?.delegate = self
    }
    
}
