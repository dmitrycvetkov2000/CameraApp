//
//  User.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 15.04.2024.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var _id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var city = ""
    @objc dynamic var avatar: Data? = nil
    @objc dynamic var mainPhoto: Data? = nil
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
