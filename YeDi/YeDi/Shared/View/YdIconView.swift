//
//  YdIconView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/21.
//

import SwiftUI

struct YdIconView: View {
    let height: CGFloat
    
    var body: some View {
        Image("ydIcon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: height)
    }
}

#Preview {
    YdIconView(height: 35)
}
