//
//  CustomTextField.swift
//  CameraApp_AVFoundation
//
//  Created by Дмитрий Цветков on 04.04.2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var name: String
    let cornerRadius: CGFloat
    let height: CGFloat
    let padding: CGFloat
    let placeholderText: String
    let activeImgName: String
    let nonActiveImgName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(colors: [.red, .yellow], startPoint: .leading, endPoint: .trailing)
                )
                .fill(
                    LinearGradient(colors: [.yellow, .red], startPoint: .leading, endPoint: .trailing)
                )
            
            HStack {
                Image(systemName: name.isEmpty ? nonActiveImgName : activeImgName)
                TextField(placeholderText, text: $name)
            }
            .padding()
        }
        .frame(height: height)
        .padding([.leading, .trailing], padding)
        
    }

}

#Preview {
    CustomTextField(name: .constant(""), cornerRadius: 20, height: 40, padding: 10, placeholderText: "Введите имя", activeImgName: "person.fill.checkmark", nonActiveImgName: "person.fill")
}
