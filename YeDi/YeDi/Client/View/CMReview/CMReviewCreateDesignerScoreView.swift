//
//  CMReviewCreateDesignerScoreView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewCreateDesignerScoreView: View {
    @Binding var designerScore: Int
    
    var body: some View {
        Section {
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= designerScore ? "star.fill" : "star")
                        .onTapGesture {
                            designerScore = index
                        }
                        .foregroundStyle(index <= designerScore ? .yellow : Color(white: 0.9))
                        .font(.title3)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        } header: {
            HStack {
                Text("별점을 남겨주세요")
                    .padding(.leading)
                    .fontWeight(.semibold)
                Spacer()
            }
            Divider()
                .frame(width: 360)
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    CMReviewCreateDesignerScoreView(designerScore: .constant(0))
}
