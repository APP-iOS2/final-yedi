//
//  CapsuleButton.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/16.
//

import SwiftUI

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
