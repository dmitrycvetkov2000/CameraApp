//
//  CustopPopOverVC.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 25.03.2024.
//

import UIKit

final class CustopPopOverVC: UIViewController {
 
// MARK: GalleryProperties
    lazy var viewForOpenGallery: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 10, width: self.view.bounds.width, height: self.view.bounds.height * 0.5 - 10)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        view.addSubview(imageForOpenGallery)
        view.addSubview(labelForOpenGallery)
        view.backgroundColor = .purple
        
        return view
    }()
    
    lazy var imageForOpenGallery: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "photo.on.rectangle.angled")
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 0.3, height: view.bounds.height)
        
        return imageView
    }()
    
    lazy var labelForOpenGallery: UILabel = {

        let label = UILabel()
        let text = "Выбрать фото из галлереи"
        label.text = text
        label.numberOfLines = 0
        label.frame = CGRect(x: imageForOpenGallery.frame.maxX + 10, y: 0, width: view.bounds.width * 0.7, height: view.bounds.height)
        
        return label
    }()
    
// MARK: CameraProperties
    lazy var viewForOpenCamera: UIView = {
        let view = UIView()

        view.frame = CGRect(x: 0, y: self.view.bounds.width * 0.6, width: self.view.bounds.width, height: self.view.bounds.width * 0.3)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true

        view.addSubview(imageViewForOpenCamera)
        view.addSubview(labelForOpenCamera)
        view.backgroundColor = .purple
        
        return view
    }()
    
    lazy var imageViewForOpenCamera: UIImageView = {

        let imageView = UIImageView()
        let image = UIImage(systemName: "camera")
        imageView.image = image

        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 0.3, height: view.bounds.height)
        
        return imageView
    }()
    
    lazy var labelForOpenCamera: UILabel = {
        
        let label = UILabel()
        let text = "Сделать фото"
        label.text = text
        label.numberOfLines = 0
        label.frame = CGRect(x: imageViewForOpenCamera.frame.maxX + 10, y: 0, width: view.bounds.width * 0.7, height: view.bounds.height)
        
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(viewForOpenGallery)
        self.view.addSubview(viewForOpenCamera)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFrames()
    }
    
    private func setFrames() {
        viewForOpenGallery.frame = CGRect(x: 0, y: 10, width: self.view.bounds.width, height: self.view.bounds.height * 0.5 - 10)
        imageForOpenGallery.frame = CGRect(x: 0, y: 0, width: viewForOpenGallery.bounds.width * 0.3, height: viewForOpenGallery.bounds.height)
        labelForOpenGallery.frame = CGRect(x: imageForOpenGallery.frame.maxX + 10, y: 0, width: viewForOpenGallery.bounds.width * 0.7, height: viewForOpenGallery.bounds.height)
        
        viewForOpenCamera.frame = CGRect(x: 0, y: self.view.bounds.height * 0.5 + 10, width: self.view.bounds.width, height: self.view.bounds.height * 0.5 - 10)
        imageViewForOpenCamera.frame = CGRect(x: 0, y: 0, width: viewForOpenCamera.bounds.width * 0.3, height: viewForOpenCamera.bounds.height)
        labelForOpenCamera.frame = CGRect(x: imageViewForOpenCamera.frame.maxX + 10, y: 0, width: viewForOpenCamera.bounds.width * 0.7, height: viewForOpenCamera.bounds.height)
    }
}

#Preview("UIKit") {
    CustopPopOverVC()
}
