//
//  TopViewForImages.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 24.03.2024.
//

import UIKit

final class TopViewForImages: UIView {
    let mainImageView = UIImageView()
    let avatarImageView = UIImageView()
    let buttonForChangeAvatarPhoto = UIButton()
    let buttonForChangeMainPhoto = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        settingsViews()
    }
    
    private func setupViews() {
        self.makeMainImageView()
        self.makeAvatarImageView()
        self.makeButtonForChangeAvatarPhoto()
        self.makeButtonForChangeMainPhoto()
    }
    
    private func settingsViews() {
        settingAvatarImageView()
        setupButtonForChangeAvatarPhoto()
        setupButtonForChangeMainPhoto()
    }
    
}

// MARK: MainItems
private extension TopViewForImages {
    func makeMainImageView() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mainImageView)
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            mainImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        mainImageView.image = UIImage(systemName: "photo.fill")
        mainImageView.clipsToBounds = true
        mainImageView.backgroundColor = .systemGreen
    }
    
    func makeButtonForChangeMainPhoto() {
        buttonForChangeMainPhoto.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(buttonForChangeMainPhoto)
        
        NSLayoutConstraint.activate([
            buttonForChangeMainPhoto.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 0),
            buttonForChangeMainPhoto.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 0),
            buttonForChangeMainPhoto.widthAnchor.constraint(equalTo: self.mainImageView.heightAnchor, multiplier: 0.24),
            buttonForChangeMainPhoto.heightAnchor.constraint(equalTo: self.mainImageView.heightAnchor, multiplier: 0.24),
        ])
        
    }
    
    func setupButtonForChangeMainPhoto() {
        buttonForChangeMainPhoto.layer.cornerRadius = buttonForChangeMainPhoto.bounds.height / 2
        buttonForChangeMainPhoto.backgroundColor = .white
        let image = UIImage(systemName: "pencil.circle")
        buttonForChangeMainPhoto.setBackgroundImage(image, for: .normal)
    }
}

// MARK: AvatarItems
private extension TopViewForImages {

    func makeAvatarImageView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 0.5),
            avatarImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 0.5)
        ])
        
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
    }
    
    func settingAvatarImageView() {
        avatarImageView.backgroundColor = .green
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.clipsToBounds = true
        
    }
    
    func makeButtonForChangeAvatarPhoto() {
        buttonForChangeAvatarPhoto.translatesAutoresizingMaskIntoConstraints = false
        buttonForChangeAvatarPhoto.backgroundColor = .white
        self.addSubview(buttonForChangeAvatarPhoto)
        
    }
    
    func setupButtonForChangeAvatarPhoto() {
        setConstarintsButtonForChangeAvatarPhoto()
        buttonForChangeAvatarPhoto.layer.cornerRadius = buttonForChangeAvatarPhoto.bounds.height / 2
        
        let image = UIImage(systemName: "pencil.line")
        buttonForChangeAvatarPhoto.setImage(image, for: .normal)
        
    }
    
    func setConstarintsButtonForChangeAvatarPhoto() {
        NSLayoutConstraint.activate([
            buttonForChangeAvatarPhoto.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor, constant: avatarImageView.frame.width * 0.35),
            buttonForChangeAvatarPhoto.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: -avatarImageView.frame.height * 0.35),
            buttonForChangeAvatarPhoto.widthAnchor.constraint(equalToConstant: avatarImageView.bounds.width * 0.25),
            buttonForChangeAvatarPhoto.heightAnchor.constraint(equalToConstant: avatarImageView.bounds.height * 0.25)
        ])
    }

}

#Preview("UIKits") {
    TopViewForImages()
}
