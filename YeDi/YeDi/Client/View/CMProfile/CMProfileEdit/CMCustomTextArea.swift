//
//  CMCustomTextArea.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/18.
//

import SwiftUI

/// 커스텀 텍스트 Area 스타일
struct CMCustomTextAreaStyle: TextFieldStyle {
    // MARK: - Body
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .frame(height: 200, alignment: .topLeading)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray6)
            )
    }
}
