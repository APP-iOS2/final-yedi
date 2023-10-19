//
//  TextAreaModifier.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/18.
//

import SwiftUI

struct TextAreaModifier: ViewModifier {
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .textFieldStyle(CustomTextAreaStyle(height: height))
    }
}

/// 커스텀 텍스트 Area 스타일
struct CustomTextAreaStyle: TextFieldStyle {
    let height: CGFloat
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .frame(height: height, alignment: .topLeading)
            .textFieldModifier()
    }
}
