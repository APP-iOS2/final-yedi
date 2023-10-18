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
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 10) {
            // MARK: - 리뷰 별점 및 작성일
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= review.designerScore ? "star.fill" : "star")
                        .foregroundStyle(index <= review.designerScore ? .yellow : Color(white: 0.9))
                        .font(.title3)
               }
                Spacer()
                
                Text("\(SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "yyyy.MM.dd.", from: review.date)) 작성")
            }
            
            // MARK: - 리뷰 사진 스크롤 뷰
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<review.imageURLStrings.count, id: \.self) { index in
                        DMAsyncImage(url: review.imageURLStrings[index])
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
            .scrollIndicators(.never)
            
            // MARK: - 리뷰 내용
            HStack {
                Text(review.content)
                Spacer()
            }
            
            // MARK: - 키워드 리뷰
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))], alignment: .leading) {
                ForEach(review.keywordReviews) { keywordReview in
                    Text("\(keywordReview.keyword)")
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(white: 0.9), lineWidth: 1)
                        )
                }
            }
        }
        .padding()
    }
}

#Preview {
    CMReviewListView()
        .environmentObject(UserAuth())
        .environmentObject(CMReviewViewModel())
}
