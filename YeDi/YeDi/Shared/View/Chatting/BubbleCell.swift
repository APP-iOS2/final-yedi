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
    
    private var chatDate: String {
        return getCalendarComponents()
    }
    
    // temp properties
    var isReadBubble: Bool = false
    
    var body: some View {
        VStack(alignment: isMyBubble ? .trailing : .leading, spacing: 0) {
            HStack(alignment: .top) {
                if !isMyBubble { profileImage }
                messageBubble
            }
        }
        .frame(maxWidth: .infinity, alignment: isMyBubble ? .trailing : .leading)
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
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
    
    private func getCalendarComponents() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: chat.date)!
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        guard let month = components.month,
           let day = components.day,
           let hour = components.hour,
           let minute = components.minute else {
            return ""
        }
        
        return "\(month)월 \(day)일 \(hour):\(minute)"
    }
}
