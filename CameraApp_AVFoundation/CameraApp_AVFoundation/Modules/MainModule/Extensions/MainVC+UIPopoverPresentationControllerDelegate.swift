//
//  MainVC+UIPopoverPresentationControllerDelegate.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 25.03.2024.
//

import UIKit

extension MainVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
