//
//  CMDesignerProfileReviewView.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/21/23.
//

import SwiftUI

struct CMDesignerProfileReviewView: View {
    var designer: Designer
    var reviews: [Review]
    var keywords: [String]
    var keywordCount: [(String, Int)]
    
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 1
    
    @State private var showAllReviews = false
    @State private var showAllKeywords = false
    
    var body: some View {
        VStack {
            if reviews.isEmpty {
                Text("리뷰가 없습니다.")
                    .foregroundStyle(Color.primaryLabel)
                    .padding()
            } else {
                if showAllKeywords {
                    ForEach(keywordCount.sorted { $0.1 > $1.1 }, id: \.0) { keyword, count in
                        HStack {
                            Text("\(keyword)")
                            Spacer()
                            Text("\(count)")
                        }
                        .foregroundStyle(Color.primaryLabel)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.quaternarySystemFill)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    ForEach(keywordCount.sorted { $0.1 > $1.1 }.prefix(4), id: \.0) { keyword, count in
                        HStack {
                            Text("\(keyword)")
                            Spacer()
                            Text("\(count)")
                        }
                        .foregroundStyle(Color.primaryLabel)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.quaternarySystemFill)
                        }
                        .padding(.horizontal)
                    }
                    if !showAllKeywords && keywordCount.count > 4 {
                        Button(action: {
                            showAllKeywords = true
                        }) {
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color.primaryLabel)
                        }
                        .padding()
                    }
                }
                
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(height: 5)
                    .padding()
                
                if showAllReviews {
                    ForEach(reviews) { review in
                        NavigationLink(destination: CMDesignerReviewDetailView(review: review)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(review.style)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.primaryLabel)
                                        Spacer()
                                        RatingView(score: review.designerScore, maxScore: 5, filledColor: .yellow)
                                    }
                                    Text(review.content)
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
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.quaternarySystemFill)
                            }
                            .padding(.horizontal)
                        }
                    }
                } else {
                    ForEach(reviews.prefix(4)) { review in
                        NavigationLink(destination: CMDesignerReviewDetailView(review: review)) {
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(review.style)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.primaryLabel)
                                        Spacer()
                                        RatingView(score: review.designerScore, maxScore: 5, filledColor: .yellow)
                                    }
                                    Text(review.content)
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
                                NavigationLink(destination: CMDesignerReviewDetailView(review: review)) {
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
                            .padding(.horizontal)
                        }
                    }
                    if !showAllReviews && reviews.count > 4 {
                        Button(action: {
                            showAllReviews = true
                        }) {
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color.primaryLabel)
                        }
                        .padding()
                    }
                }
                
            }
        }
    }
}

//#Preview {
//    CMDesignerProfileReviewView()
//}
