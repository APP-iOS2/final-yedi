//
//  CapsuleButton.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/16.
//

import SwiftUI

/// 상담하기, 팔로잉/팔로우 버튼 같은 캡슐 형태 버튼 커스텀
/// - isFollowed는 팔로잉/팔로우를 위한 파라미터이므로 사용하지 않을 시 nil 값 전달하시면 됩니다.
/// - 사용 형태: CapsuleButton(text:, isFollowed:) { action... }
struct CapsuleButton: View {
    let text: String
    let isFollowed: Bool?
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(isFollowed ?? true ? .black : .white)
                .padding(.horizontal, 20)
                .padding(.vertical, 7)
                .background(isFollowed ?? true ? .white : .black)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isFollowed ?? true ? .black : .clear, lineWidth: 1)
                )
        }

    }
}
