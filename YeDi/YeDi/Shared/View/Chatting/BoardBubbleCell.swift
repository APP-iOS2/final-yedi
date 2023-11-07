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
            AsnycCacheImage(url: boardBubble.imagePath ?? "")
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 220)
            
            Text(boardBubble.content ?? "")
        }
        .chatBubbleModifier(isMyBubble)
    }
}
