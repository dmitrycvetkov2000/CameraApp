//
//  MainVC.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 24.03.2024.
//

import UIKit
import SwiftUI

final class MainVC: UIViewController {
    let viewModel: MainViewModelProtocol
    let topImagesView = TopViewForImages()
    let containerTextFieldsView = UIView()
    let textFieldsView = UIHostingController(rootView: TextFieldsView())
    private let buttonForUpdatePhoto = UIButton()
    private let cameraVC: CameraVC
    private let imagePicker: ImagePicker
    private let popOverVC = CustopPopOverVC()
    
    private lazy var completionImagePicker: ((UIImage) -> ())? = { image in
        self.setPhoto(photo: image)
    }
    
    init(viewModel: MainViewModelProtocol, cameraViewModel: CameraViewModelProtocol) {
        self.viewModel = viewModel
        self.cameraVC = CameraVC(viewModel: cameraViewModel)
        self.imagePicker = ImagePicker(imagePickerVC: UIImagePickerController())
        
        super.init(nibName: nil, bundle: nil)
        
        self.imagePicker.completion = completionImagePicker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTapGesturesOnViewsOfPopover()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldsView.view.frame = containerTextFieldsView.bounds
    }
    
    private func setupViews() {
        setupTopImagesView()
        setupTextFieldsView()
        addTargetsOnButtons()
        cameraVC.delegateOfCamera = self
        self.view.backgroundColor = .brown
    }
    
    private func bindViewModel() {
        viewModel.isAvatarChange.bind { [weak self] isAvatarChange in
            guard let self = self, let isAvatarChange = isAvatarChange else { return }
            
            DispatchQueue.main.async {
                if isAvatarChange {
                    // To do
                } else {
                    // To do
                }
            }
        }
        
    }
}

// MARK: TopImagesView
private extension MainVC {
    func setupTopImagesView() {
        topImagesView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topImagesView)
        NSLayoutConstraint.activate([
            topImagesView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            topImagesView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topImagesView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            topImagesView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    func addTargetsOnButtons() {
        topImagesView.buttonForChangeMainPhoto.addTarget(self, action: #selector(changeMainPhoto), for: .touchUpInside)
        topImagesView.buttonForChangeAvatarPhoto.addTarget(self, action: #selector(changeAvatarPhoto), for: .touchUpInside)
    }
    @objc func changeMainPhoto() {
        self.viewModel.isAvatarChange.value = false
        showPopover(sourceView: topImagesView.buttonForChangeMainPhoto, x: topImagesView.buttonForChangeMainPhoto.bounds.midX, y: topImagesView.buttonForChangeMainPhoto.bounds.maxY)

    }
    @objc func changeAvatarPhoto() {
        self.viewModel.isAvatarChange.value = true
        showPopover(sourceView: topImagesView.buttonForChangeAvatarPhoto, x: topImagesView.buttonForChangeAvatarPhoto.bounds.midX, y: topImagesView.buttonForChangeAvatarPhoto.bounds.maxY)

    }
    
}

// MARK: TextFieldsView
private extension MainVC {
    func setupTextFieldsView() {
        containerTextFieldsView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsView.view.backgroundColor = .clear
        self.view.addSubview(containerTextFieldsView)
    
        NSLayoutConstraint.activate([
            containerTextFieldsView.topAnchor.constraint(equalTo: self.topImagesView.avatarImageView.bottomAnchor, constant: 0),
            containerTextFieldsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerTextFieldsView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            containerTextFieldsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        addChild(textFieldsView)
        
        textFieldsView.view.frame = containerTextFieldsView.bounds
        containerTextFieldsView.addSubview(textFieldsView.view)
        textFieldsView.didMove(toParent: self)
    }
}

// MARK: Popover
private extension MainVC {
    func showPopover(sourceView: UIView, x: CGFloat, y: CGFloat) {
        popOverVC.modalPresentationStyle = .popover
        popOverVC.preferredContentSize = CGSize(width: self.view.bounds.width * 0.5, height: self.view.bounds.width * 0.4)
        
        guard let presentationVC = popOverVC.popoverPresentationController else { return }
        presentationVC.delegate = self
        presentationVC.sourceView = sourceView
        presentationVC.permittedArrowDirections = .up

        presentationVC.sourceRect = CGRect(x: x, y: y, width: 0, height: 0)

        if self.presentedViewController == nil {
            present(popOverVC, animated: true)
        }
    }
    
    func addTapGesturesOnViewsOfPopover() {
        let gestureRecognizerOpenGallery = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        popOverVC.viewForOpenGallery.addGestureRecognizer(gestureRecognizerOpenGallery)
        
        let gestureRecognizerOpenCamera = UITapGestureRecognizer(target: self, action: #selector(openCamera))
        popOverVC.viewForOpenCamera.addGestureRecognizer(gestureRecognizerOpenCamera)
    }
    @objc func openCamera() {
        print("openCamera")
        openCameraOrGalleryModule(vc: self.cameraVC)
    }
    @objc func openGallery() {
        print("openGallery")
        openCameraOrGalleryModule(vc: self.imagePicker.imagePickerVC ?? UIImagePickerController())
    }
    
    private func openCameraOrGalleryModule(vc: UIViewController) {
        if self.presentedViewController == nil {
            self.present(vc, animated: true, completion: nil)
        } else {
            self.presentedViewController!.present(vc, animated: true, completion: nil)
        }
    }
}

#Preview("UIKit") {
    MainVC(viewModel: MainViewModel(), cameraViewModel: CameraViewModel())
}


