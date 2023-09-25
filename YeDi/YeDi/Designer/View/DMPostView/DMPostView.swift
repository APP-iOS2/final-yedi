//
//  DMPostView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMPostView: View {
    let selectedPost: Post  // 선택된 게시글

    var body: some View {
        // 컨텐츠 배치
        VStack(alignment: .leading, spacing: 16) {
            // 디자이너 정보와 위치
            HStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: DMProfileView()) {
                        Text(selectedPost.designerID)
                            .font(.headline)
                            .foregroundColor(Color.black)
                    }
                    NavigationLink(destination: DMProfileView()) {
                        Text("\(selectedPost.location) | \(selectedPost.title)")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            // 게시글 사진
            ForEach(selectedPost.photos, id: \.id) { photo in
                AsyncImage(url: photo.imageURL)
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
            }
            // 게시글 설명
            if let description = selectedPost.description {
                Text(description)
                    .foregroundColor(Color.black)
                    .padding(.horizontal)
            }
            // 게시 시간
            Text(selectedPost.timestamp)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    DMGridView()
}
