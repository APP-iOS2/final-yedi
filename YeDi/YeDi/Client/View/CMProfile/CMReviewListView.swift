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
                        Text("\(review.designerScore)")
                    }
                }
                .refreshable {
                    Task {
                        await reviewViewModel.fetchReview(userAuth: userAuth)
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

#Preview {
    CMReviewListView()
        .environmentObject(CMReviewViewModel())
}
