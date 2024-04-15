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
                savePhotoToBD(photo: photo, isAvatar: true)
            } else {
                self.topImagesView.mainImageView.image = photo
                savePhotoToBD(photo: photo, isAvatar: false)
            }
        }
        
    }
    
    private func savePhotoToBD(photo: UIImage, isAvatar: Bool) {
        var data: Data? 
        let dataSize = sizeInMbOfData(data: data!)
        
        if dataSize > 15.9 {
            data = photo.jpegData(compressionQuality: 0.5)
        } else {
            data = photo.pngData()
        }
        
        let user = User()
        setValues(isAvatar: isAvatar, object: user, data: data ?? Data())
        
        RealmManager.shared.saveObject(object: user) { user in
            setValues(isAvatar: isAvatar, object: user, data: data ?? Data())
        }
    }
    
    private func setValues(isAvatar: Bool, object: AnyObject, data: Data) {
        if let user = object as? User {
            if isAvatar {
                try! RealmManager.shared.realm.write {
                    user.avatar = data
                }
                
            } else {
                try! RealmManager.shared.realm.write {
                    user.mainPhoto = data
                }
            }
        }

    }
    
    func sizeInMbOfData(data: Data) -> Double {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(data.count))
        if let double = Double(string.replacingOccurrences(of: " MB", with: "")) {
            return double
        } else {
            return 1000
        }

    }
}
