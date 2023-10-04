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
        AsyncImage(url: URL(string: imagePath)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 220)
        } placeholder: {
            ProgressView()
        }
    }
}
