//
//  MainVC+CameraDelegate.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 25.03.2024.
//

import UIKit

// MARK: Camera
extension MainVC: CameraDelegate {
    func setPhoto(photo: UIImage) {
        if let isAvatarChange = viewModel.isAvatarChange.value {
            if isAvatarChange {
                self.topImagesView.avatarImageView.image = photo
            } else {
                self.topImagesView.mainImageView.image = photo
            }
        }
        
    }
    
}
