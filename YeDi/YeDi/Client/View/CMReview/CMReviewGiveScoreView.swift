//
//  CMReviewGiveScoreView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewGiveScoreView: View {
    // MARK: - Properties
    @Binding var reviewScore: Int
    
    // MARK: - Body
    var body: some View {
        Section {
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= reviewScore ? "star.fill" : "star")
                        .onTapGesture {
                            reviewScore = index
                        }
                        .font(.title3)
                        .foregroundStyle(index <= reviewScore ? .yellow : Color.systemFill)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        } header: {
            HStack {
                Text("별점을 남겨주세요")
                    .fontWeight(.semibold)
                    .padding(.leading)
                Spacer()
            }
            Divider()
                .frame(width: 360)
                .background(Color.systemFill)
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    CMReviewGiveScoreView(reviewScore: .constant(0))
}
