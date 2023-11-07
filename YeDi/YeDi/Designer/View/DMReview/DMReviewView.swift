//
//  DMReviewView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMReviewView: View {
    
    @ObservedObject var reviewsModel = ReviewModel()
    
    var body: some View {
        NavigationStack {
            if reviewsModel.reviews.isEmpty {
                Text("등록된 리뷰가 없습니다.")
                    .navigationTitle("내 리뷰")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            YdIconView(height: 32)
                        }
                    }
            } else {
                List(reviewsModel.reviews) { review in
                    NavigationLink {
                        DMReviewDetailView(review: review)
                    } label: {
                        DMReviewCell(review: review)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("내 리뷰")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        YdIconView(height: 32)
                    }
                }
            }
        }
        .onAppear {
            reviewsModel.fetchReviews()
        }
    }
}

struct DMReviewCell: View {
    let review: Review
    
    var body: some View {
        HStack {
            AsnycCacheImage(url: review.imageURLStrings[0])
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading){
                HStack(spacing: 0.5){
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.designerScore ? "star.fill" : "star")
                            .foregroundStyle(index <= review.designerScore ? .yellow : Color(white: 0.9))
                            .font(.title3)
                    }
                }
                Text("\(review.content)")
                    .lineLimit(1)
                
            }
        }
    }
}

#Preview {
    DMReviewView()
       
}
