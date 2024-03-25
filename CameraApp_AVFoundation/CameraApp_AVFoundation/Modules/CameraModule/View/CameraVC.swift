//
//  CameraVC.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 20.03.2024.
//

import UIKit
import AVFoundation

protocol CameraDelegate: AnyObject {
    func setPhoto(photo: UIImage)
}

final class CameraVC: UIViewController {

    private let viewModel: CameraViewModelProtocol
    private let buttonSwitch = UIButton()
    let imageView = UIImageView()
    
    weak var delegateOfCamera: CameraDelegate?
    
    init(viewModel: CameraViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViews()
    }
    
    private func setupInitialViews() {
        checkPermissions()
        setupPreviewLayer()
        viewModel.cameraService.setupCaptureSession()
        
        createButtonMakePhoto()
        createButtonSwitchCamera()
        createImageView()
    }

    deinit {
        viewModel.cameraService.stopSession()
    }
    
}

// MARK: CreateButtons
private extension CameraVC {
    func createButtonMakePhoto() {
        let button = UIButton()
        let height: CGFloat = 60
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: height),
            button.heightAnchor.constraint(equalToConstant: height)
        ])

        button.layer.cornerRadius = height / 2
        button.backgroundColor = UIColor.gray

        button.addTarget(self, action: #selector(makePhoto), for: .touchUpInside)
    }
    @objc func makePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        self.viewModel.cameraService.output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func createButtonSwitchCamera() {
        let height: CGFloat = 60
        buttonSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonSwitch)
        
        NSLayoutConstraint.activate([
            buttonSwitch.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonSwitch.widthAnchor.constraint(equalToConstant: height),
            buttonSwitch.heightAnchor.constraint(equalToConstant: height)
        ])

        buttonSwitch.layer.cornerRadius = height / 2
        buttonSwitch.backgroundColor = UIColor.gray
        
        buttonSwitch.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
    }
    @objc func switchCamera() {
        viewModel.cameraService.switchCamera()
    }
    
}

// MARK: CreateViews
private extension CameraVC {
    func createImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.cameraService.cameraSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
}

// MARK: Permissions
extension CameraVC {
    private func checkPermissions() {
        let cameraStatusAuth = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraStatusAuth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { auth in
                if !auth {
                    abort()
                }
            }
        case .restricted:
            abort()
        case .denied:
            abort()
        case .authorized:
            return
        default:
            print("error checkPermissions")
        }
    }
}


