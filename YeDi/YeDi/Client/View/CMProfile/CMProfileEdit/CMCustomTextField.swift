//
//  CMCustomTextField.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI

/// 커스텀 텍스트 필드 스타일
/// - 흰 바탕에 회색 RoundedRectangle 테두리
/// - .textFieldStyle(CMCustomTextFieldStyle()) 형태로 사용
struct CMCustomTextFieldStyle: TextFieldStyle {
    // MARK: - Body
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.systemFill, lineWidth: 1)
            )
    }
}
