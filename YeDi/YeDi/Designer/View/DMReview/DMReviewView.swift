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
            List(reviewsModel.reviews) { review in
                NavigationLink {
                    DMReviewDetailView(review: review)
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: "\(review.imageURLStrings)")) { item in
                            item
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("평점: \(review.designerScore)점")
                            Text("\(review.content)")
                                .lineLimit(1)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("내 리뷰")
        }
    }
    
    init() {
        reviewsModel.getData()
    }
}

#Preview {
    DMReviewView()
       
}
