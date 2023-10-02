//
//  BubbleCell.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/30.
//

import SwiftUI

struct BubbleCell: View {
    var chat: CommonBubble
    var messageType: MessageType
    var isMyBubble: Bool
    
    // temp properties
    var isReadBubble: Bool = false
    private var chatDate: String {
        let formatter = DateFormatter()
        let date = formatter.date(from: chat.date) ?? Date()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: isMyBubble ? .trailing : .leading) {
            HStack(alignment: .top) {
                if !isMyBubble { profileImage }
                messageBubble
            }
        }
        .frame(maxWidth: .infinity, alignment: isMyBubble ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
    
    private var profileImage: some View {
        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2487&q=80")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 30, height: 30)
        } placeholder: {
            ProgressView()
        }
    }
    
    private var messageBubble: some View {
        HStack(alignment: .bottom) {
            if isMyBubble {
                if !isReadBubble {
                    Text("1")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                
                Text("\(chatDate)")
                    .font(.caption2)
                    .foregroundStyle(.gray)
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
                Text("\(chatDate)")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                if !isReadBubble {
                    Text("1")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}
