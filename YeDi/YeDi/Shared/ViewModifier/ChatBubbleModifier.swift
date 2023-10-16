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
            .foregroundColor(isMyChat ? .white : .black)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isMyChat ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
            }
    }
}
