//
//  CMReviewListView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMReviewListView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    
    var body: some View {
        VStack {
            if reviewViewModel.reviews.isEmpty {
                Text("작성된 리뷰가 없습니다.")
                    .padding()
            } else {
                ScrollView {
                    ForEach(reviewViewModel.reviews) { review in
                        CMReviewCell(review: review)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await reviewViewModel.fetchReview(userAuth: userAuth)
            }
        }
    }
}

struct CMReviewCell: View {
    let review: Review
    
    var body: some View {
        VStack {
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= review.designerScore ? "star.fill" : "star")
                        .foregroundStyle(index <= review.designerScore ? .yellow : Color(white: 0.9))
                        .font(.title3)
                }
                Spacer()
                Text("\(review.date)")
            }
            HStack {
                Text(review.content)
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    CMReviewListView()
        .environmentObject(CMReviewViewModel())
}
