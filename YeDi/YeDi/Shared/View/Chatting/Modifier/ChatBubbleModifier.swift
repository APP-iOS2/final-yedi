//
//  ChatBubbleModifier.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//
import SwiftUI

extension View {
    func chatBubbleModifier(_ isMyChat: Bool) -> some View {
        return modifier(ChatBubbleModifier(isMyChat: isMyChat))
    }
}

struct ChatBubbleModifier: ViewModifier {
    var isMyChat: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 11)
            .foregroundColor(isMyChat ? .white : .black)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isMyChat ? .blue : .gray.opacity(0.4))
            }
    }
}
