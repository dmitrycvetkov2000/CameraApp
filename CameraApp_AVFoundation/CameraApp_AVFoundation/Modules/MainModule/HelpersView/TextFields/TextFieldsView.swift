//
//  TextFieldsView.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 05.04.2024.
//

import SwiftUI

struct TextFieldsView: View {
    @State var name: String = ""
    @State var city: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(name: $name, cornerRadius: 10, height: 40, padding: 10, placeholderText: "Введите имя", activeImgName: "person.fill.checkmark", nonActiveImgName: "person.fill")
            CustomTextField(name: $city, cornerRadius: 10, height: 40, padding: 10, placeholderText: "Введите город", activeImgName: "scribble.variable", nonActiveImgName: "pencil.and.outline")
            Spacer()
        }
        .padding(.top)
        
    }
}

#Preview {
    TextFieldsView()
}
