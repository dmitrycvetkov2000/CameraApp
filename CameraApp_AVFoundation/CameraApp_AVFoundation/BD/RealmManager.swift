//
//  RealmManager.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 15.04.2024.
//

import RealmSwift

final class RealmManager {
    
    static let shared = RealmManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func saveObject(object: Object, completion: (Object) -> Void) {
        
        let objects = getObjects(type: type(of: object))
        
        if let object = objects.first {
            completion(object)
        } else {
            try! realm.write {
                realm.add(object)
            }
        }
        
    }
    
    func getObjects(type: Object.Type) -> Results<Object> {
        return realm.objects(type)
    }
    
    private func deleteObjects(type: Object.Type) {
        let objects = getObjects(type: type)
        realm.delete(objects)
    }
    
}
