//
//  DismissButton.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/16.
//

import SwiftUI

/// 뒤로가기 버튼 커스텀
/// - color 파라미터에 nil값 입력 시 Color.primary 값이 적용됩니다.
/// - 현재 구조체에서 dismiss() 실행하고 있으므로 다른 뷰에서 사용 시 적용하지 않아도 됩니다.
/// - 사용 형태: DismissButton(color:) { action... }
struct DismissButton: View {
    @Environment(\.dismiss) var dismiss
    
    let color: Color?
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3)
                .foregroundStyle(color ?? .primary)
        }
    }
}
