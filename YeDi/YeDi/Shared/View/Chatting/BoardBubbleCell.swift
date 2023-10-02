//
//  BoardBubbleCell.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct BoardBubbleCell: View {
    var boardBubble: CommonBubble
    var isMyBubble: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: boardBubble.imagePath ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 220)
            } placeholder: {
                ProgressView()
            }
            
            Text(boardBubble.content ?? "")
        }
        .chatBubbleModifier(isMyBubble)
    }
}
