//
//  ImageBubbleCell.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct ImageBubbleCell: View {
    var imagePath: String
    
    var body: some View {
        AsnycCacheImage(url: imagePath)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 220)
    }
}
