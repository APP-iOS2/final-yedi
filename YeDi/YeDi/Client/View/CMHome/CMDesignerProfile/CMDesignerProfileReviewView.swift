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
                
                ForEach(reviews.prefix(5)) { review in
                    HStack(alignment: .top) {
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(review.style)
                                    .fontWeight(.bold)
                                Spacer()
                                RatingView(score: review.designerScore, maxScore: 5, filledColor: .yellow)
                            }
                            Text(review.content)
                                .lineLimit(2)
                            Spacer()
                            Text("\(SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "yyyy년 MM월 dd일", from: review.date))")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        .padding(.vertical)
                        .padding(.leading)
                        DMAsyncImage(url: review.imageURLStrings[0])
                            .scaledToFill()
                            .frame(width: imageDimension, height: imageDimension)
                            .clipped()
                            .cornerRadius(8)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.quaternarySystemFill)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

//#Preview {
//    CMDesignerProfileReviewView()
//}
