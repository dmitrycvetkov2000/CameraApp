//
//  MainViewModel.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 24.03.2024.
//

import Foundation

protocol MainViewModelProtocol {
    var isAvatarChange: Observable<Bool> { get set }
}

class MainViewModel: MainViewModelProtocol {
    var isAvatarChange: Observable<Bool> = Observable(false)
}
