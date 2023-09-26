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
        // 스크롤뷰 추가
        ScrollView {
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
                        .cornerRadius(10)
                        .padding(.bottom, 8)
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
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct DMPostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전")
        
        DMPostView(selectedPost: samplePost)
    }
}
