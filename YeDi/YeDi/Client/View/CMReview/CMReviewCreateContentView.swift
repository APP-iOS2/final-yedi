//
//  CMReviewCreateContentView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewCreateContentView: View {
    @Binding var reviewContent: String
    
    var body: some View {
        Section {
            TextField("리뷰를 작성해주세요.", text: $reviewContent, axis: .vertical)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color(white: 0.9), lineWidth: 1)
                )
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 50, trailing: 0))
        } header: {
            HStack {
                Text("리뷰를 남겨주세요")
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
    CMReviewCreateContentView(reviewContent: .constant(""))
}