//
//  CMReviewListView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMReviewListView: View {
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    
    var body: some View {
        VStack {
            if reviewViewModel.reviews.isEmpty {
                Text("작성된 리뷰가 없습니다.")
                    .padding()
            } else {
                List {
                    ForEach(reviewViewModel.reviews) { review in
                        Text("\(review.content)")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await reviewViewModel.fetchReview()
            }
        }
    }
}

#Preview {
    CMReviewListView()
        .environmentObject(CMReviewViewModel())
}
