//
//  BubbleCell.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/30.
//

import SwiftUI

struct BubbleCell: View {
    var chat: CommonBubble
    var isMyBubble: Bool
    
    private var chatDate: String {
        let instance = SingleTonDateFormatter.sharedDateFommatter
        let date = instance.changeDateString(transition: "MM월 dd일 HH:mm", from: chat.date)
        return date
    }
    
    var body: some View {
        VStack(alignment: isMyBubble ? .trailing : .leading, spacing: 0) {
            HStack(alignment: .top) {
                messageBubble
            }
        }
        .frame(maxWidth: .infinity, alignment: isMyBubble ? .trailing : .leading)
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
    }
    
    private var messageBubble: some View {
        HStack(alignment: .bottom) {
            if isMyBubble {
                HStack(alignment: .center) {
                    if !chat.isRead {
                        readMarkCircle
                    }
                    chatDateMark
                }
            }
            
            switch chat.messageType {
            case .textBubble:
                Text(chat.content ?? "")
                    .chatBubbleModifier(isMyBubble)
            case .imageBubble:
                ImageBubbleCell(imagePath: chat.imagePath ?? "")
            case .boardBubble:
                BoardBubbleCell(boardBubble: chat, isMyBubble: isMyBubble)
            }
            
            if !isMyBubble {
                HStack(alignment: .center) {
                    chatDateMark
                    if !chat.isRead {
                        readMarkCircle
                    }
                }
            }
        }
    }
    
    private var chatDateMark: some View {
        Text("\(chatDate)")
            .font(.caption2)
            .foregroundStyle(.gray)
    }
    
    private var readMarkCircle: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundStyle(Color(red: 1, green: 0.19, blue: 0.53))
    }
}
