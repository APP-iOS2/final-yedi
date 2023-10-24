//
//  CMReviewListView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

/// 리뷰 리스트 뷰
struct CMReviewListView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    
    // MARK: - Body
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

/// 리뷰 셀 뷰
struct CMReviewCell: View {
    // MARK: - Properties
    let review: Review
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 1
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(review.style)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.primaryLabel)
                        Spacer()
                        RatingView(score: review.designerScore, maxScore: 5, filledColor: .yellow)
                    }
                    .padding(.bottom, 3)
                    
                    Text(review.content)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.primaryLabel)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    
                    Text("\(SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "yyyy년 MM월 dd일", from: review.date))")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                .padding(.vertical)
                .padding(.leading)
                
                ZStack(alignment: .topTrailing) {
                    DMAsyncImage(url: review.imageURLStrings[0])
                        .scaledToFill()
                        .frame(width: imageDimension, height: imageDimension)
                        .clipped()
                        .cornerRadius(8)
                    
                    if review.imageURLStrings.count > 1 { // 이미지가 여러 장인 경우에만 아이콘 표시
                        Image(systemName: "square.on.square.fill")
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.quaternarySystemFill)
        }
        .padding()
    }
}

#Preview {
    CMReviewListView()
        .environmentObject(UserAuth())
        .environmentObject(CMReviewViewModel())
}
