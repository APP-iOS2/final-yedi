//
//  DMPostView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMPostView: View {
    // 샘플 게시글 데이터
    let samplePosts = [
        Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "Post 1", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전"),
        Post(id: "2", designerID: "원장루디", location: "예디샵 홍대지점", title: "Post 2", description: "This is post 2", photos: [Photo(id: "p2", imageURL: "https://i.pinimg.com/564x/9a/bc/3a/9abc3a447d42aaa0f4be2e85eeb16ddc.jpg")], comments: 3, timestamp: "2시간 전")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                // 게시글 루프
                ForEach(samplePosts, id: \.id) { post in
                    postCard(for: post)
                }
            }
            .navigationBarTitle("내 게시글", displayMode: .large)
        }
    }
    
    // 게시글 카드
    private func postCard(for post: Post) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            header(for: post)
            imageSection(for: post)
            descriptionSection(for: post)
        }
        .padding(.vertical, 16)
    }
    
    // 헤더 (디자이너 이름, 위치)
    private func header(for post: Post) -> some View {
        HStack {
            profileInfo(for: post)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    // 프로필 정보
    private func profileInfo(for post: Post) -> some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: DMProfileView()) {
                Text(post.designerID).font(.headline).foregroundColor(.black)
            }
            NavigationLink(destination: DMProfileView()) {
                Text(post.location).font(.caption).foregroundColor(.gray)
            }
        }
    }
    
    // 이미지 섹션
    private func imageSection(for post: Post) -> some View {
        NavigationLink(destination: PostDetailView(post: post)) {
            ForEach(post.photos, id: \.id) { photo in
                AsyncImage(url: photo.imageURL).scaledToFill().frame(height: 300).clipped()
            }
        }
    }
    
    // 설명 섹션
    private func descriptionSection(for post: Post) -> some View {
        VStack(alignment: .leading) {
            if let description = post.description {
                Text(description).foregroundColor(.black).padding(.horizontal)
            }
            Text(post.timestamp).font(.caption).foregroundColor(.gray).padding(.horizontal)
        }
    }
}

struct PostDetailView: View {
    let post: Post
    var body: some View {
        Text(post.title)
    }
}

struct DMPostView_Previews: PreviewProvider {
    static var previews: some View {
        DMPostView()
    }
}

#Preview {
    DMPostView()
}
