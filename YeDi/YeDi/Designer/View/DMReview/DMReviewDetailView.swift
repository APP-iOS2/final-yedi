//
//  DMReviewDetailView.swift
//  YeDi
//
//  Created by 송성욱 on 10/6/23.
//

import SwiftUI
import FirebaseFirestore


struct DMReviewDetailView: View {
    
    var review: Review
    
    var body: some View {
        List {
            Section("고객명") {
                Text("\(review.reviewer)")
            }
            Section("작성일") {
                Text("\(review.date)")
            }
            Section("평점") {
                Text("\(review.designerScore)")
            }
            Section("디자이너 스타일 평가") {
                Text("\(review.id)")
            }
            Section("리뷰 내용") {
                Text("\(review.content)")
            }
        }
        .listStyle(.plain)
    }
}

//#Preview {
//    DMReviewDetailView()
//}
