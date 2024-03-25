//
//  CameraViewModel.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 25.03.2024.
//

import Foundation

protocol CameraViewModelProtocol {
    var cameraService: CameraServiceProtocol { get set }
}

class CameraViewModel: CameraViewModelProtocol {
    var cameraService: CameraServiceProtocol = CameraService()
}

