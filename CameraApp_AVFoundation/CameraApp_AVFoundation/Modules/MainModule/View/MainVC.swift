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
    private var animation: CAKeyframeAnimation?
    
    private var animatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
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
        setAnimatedView()
        startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldsView.view.frame = containerTextFieldsView.bounds
    }
    
    private func setupViews() {
        setupTopImagesView()
        setupTextFieldsView()
        addTargetsOnButtons()
        setSaveBtn()
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
    
    private func setSaveBtn() {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 20
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        
        btn.frame = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY - 80, width: 200, height: 40)
        btn.center.x = self.view.center.x
        
        self.view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(saveToBD), for: .touchUpInside)
    }
    
    @objc func saveToBD() {
        let user = User()
        setValues(user: user)
        
        RealmManager.shared.saveObject(object: user) { object in
            setValues(user: user)
        }
    }
    
    private func setValues(user: AnyObject) {
        if let user = user as? User {
            try! RealmManager.shared.realm.write {
                user.name = self.textFieldsView.rootView.viewModel.name
                user.city = self.textFieldsView.rootView.viewModel.city
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
        
        self.textFieldsView.rootView.viewModel.setupTextsOnTextFeilds()
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

// MARK: Animation
private extension MainVC {
    func setAnimatedView() {
        self.view.addSubview(animatedView)
        animatedView.frame = CGRect(x: 0, y: self.view.bounds.maxY, width: 40, height: 40)
        setArrowOnView()
    }
    
    func setupAnimation() {
        let path = UIBezierPath()
        path.lineWidth = 2
        path.move(to: CGPoint(x: 0, y: self.view.bounds.maxY))
        path.addCurve(to: CGPoint(x: self.topImagesView.buttonForChangeAvatarPhoto.frame.minX - animatedView.bounds.width / 2, y: self.topImagesView.buttonForChangeAvatarPhoto.frame.maxY), controlPoint1: CGPoint(x: 100, y: 100), controlPoint2: CGPoint(x: 200, y: 100))
        
        animation = CAKeyframeAnimation(keyPath: "position")
        animation?.path = path.cgPath

        animation?.repeatCount = Float.infinity
        animation?.duration = 5.0
    }
    
    func startAnimation() {
        setupAnimation()
        guard let animation = animation else { return }
        self.animatedView.layer.add(animation, forKey: nil)
    }
    
    func setArrowOnView() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        animatedView.layer.addSublayer(shapeLayer)
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: animatedView.bounds.maxY))
        path2.addLine(to: CGPoint(x: animatedView.bounds.maxX, y: animatedView.bounds.minY))
        path2.addLine(to: CGPoint(x: animatedView.bounds.maxX, y: animatedView.bounds.midY))
        path2.move(to: CGPoint(x: animatedView.bounds.maxX, y: animatedView.bounds.minY))
        path2.addLine(to: CGPoint(x: animatedView.bounds.midX, y: animatedView.bounds.minY))
        
        shapeLayer.path = path2.cgPath
    }
}

#Preview("UIKit") {
    MainVC(viewModel: MainViewModel(), cameraViewModel: CameraViewModel())
}
