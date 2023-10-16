//
//  CMCustomTextField.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI

/// 커스텀 텍스트 필드 스타일
struct CMCustomTextFieldStyle: TextFieldStyle {
    // MARK: - Body
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color(white: 0.9), lineWidth: 1)
            )
    }
}
