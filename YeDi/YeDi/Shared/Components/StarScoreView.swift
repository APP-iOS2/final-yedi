//
//  StarScoreView.swift
//  YeDi
//
//  Created by 김성준 on 10/17/23.
//

import SwiftUI

struct StarScoreView: View {
    let score: Int
    var body: some View {
        ForEach(1...5, id: \.self) { index in
            Image(systemName: index <= score ? "star.fill" : "star")
                .foregroundStyle(index <= score ? .yellow : Color(white: 0.9))
                .font(.title3)
       }
    }
}

#Preview {
    StarScoreView(score: 5)
}
