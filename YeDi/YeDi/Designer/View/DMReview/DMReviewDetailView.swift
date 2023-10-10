//
//  DMReviewDetailView.swift
//  YeDi
//
//  Created by 송성욱 on 10/6/23.
//

import SwiftUI
import FirebaseFirestore


struct DMReviewDetailView: View {
    
    var body: some View {
        List {
            Section("고객명") {
                Text("김고객")
            }
            Section("작성일") {
                Text("2023.10.9")
            }
            Section("평점") {
                HStack {
                    ForEach(0...4, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            Section("디자이너 스타일 평가") {
                Text("너무 좋아요")
            }
            Section("리뷰 내용") {
                Text("""
                왜 이제야 쌤을 발견했을까요! 덕분에 정말 인생 머리를 해서 너무 기분이 좋습니다. 요즘 만나는 사람들도 다 이쁘다고 칭찬해주시네요. 너무 감사합니다!
                """)
            }
            Section("시술 이미지") {
                ScrollView(.horizontal) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width:120, height: 120)
                            .foregroundColor(.gray)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    DMReviewDetailView()
}
