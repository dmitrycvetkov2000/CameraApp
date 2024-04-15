//
//  TextFieldViewModel.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 15.04.2024.
//

import SwiftUI

class TextFieldViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var city: String = ""
    
    func setupTextsOnTextFeilds() {
        let users = RealmManager.shared.getObjects(type: User.self)
        
        if let user = users.first as? User {
            name = user.name
            city = user.city
        }
    }
}
