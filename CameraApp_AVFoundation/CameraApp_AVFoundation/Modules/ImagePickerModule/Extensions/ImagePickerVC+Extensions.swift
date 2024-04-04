//
//  ImagePickerVC+Extensions.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 04.04.2024.
//

import UIKit

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.completion?(image)
            picker.dismiss(animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
