//
//  CMReviewWriteContentView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewWriteContentView: View {
    // MARK: - Properties
    @Binding var reviewContent: String
    
    // MARK: - Body
    var body: some View {
        Section {
            TextField("리뷰를 작성해주세요.", text: $reviewContent, axis: .vertical)
                .textFieldStyle(CMCustomTextAreaStyle())
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 50, trailing: 20))
        } header: {
            HStack {
                Text("리뷰를 남겨주세요")
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
    CMReviewWriteContentView(reviewContent: .constant(""))
}
