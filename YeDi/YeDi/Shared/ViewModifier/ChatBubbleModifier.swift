//
//  ChatBubbleModifier.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct ChatBubbleModifier: ViewModifier {
    var isMyChat: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 11)
            .foregroundColor(isMyChat ? .white : .primaryLabel)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isMyChat ? .mainColor : Color.gray5)
            }
    }
}
