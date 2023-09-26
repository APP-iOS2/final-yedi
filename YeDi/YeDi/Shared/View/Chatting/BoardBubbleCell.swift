//
//  BoardBubbleCell.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct BoardBubbleCell: View {
    var boardBubble: BoardBubble
    var isMyChat: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: boardBubble.imagePath)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 220)
            } placeholder: {
                ProgressView()
            }
            
            Text(boardBubble.content)
        }
        .chatBubbleModifier(isMyChat)
    }
}

#Preview {
    BoardBubbleCell(boardBubble: BoardBubble(content: "게시물 버블 테스트", imagePath: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2487&q=80", date: "2023.01.04", sender: "김윤지"), isMyChat: true)
}
