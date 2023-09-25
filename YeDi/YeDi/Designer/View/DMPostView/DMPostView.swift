//
//  DMPostView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMPostView: View {
    // 가짜 게시물 데이터
    let samplePosts: [Post] = [
          Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "Post 1", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1 hour ago"),
          Post(id: "2", designerID: "원장루디", location: "예디샵 홍대지점", title: "Post 2", description: "This is post 2", photos: [Photo(id: "p2", imageURL: "https://i.pinimg.com/564x/9a/bc/3a/9abc3a447d42aaa0f4be2e85eeb16ddc.jpg")], comments: 3, timestamp: "2 hours ago")
      ]
    

    
    var body: some View {
        NavigationView {
            List {
                ForEach(samplePosts, id: \.id) { post in
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Profile and Username
                        HStack {
                            AsyncImage(url: "https://i.pinimg.com/564x/b3/21/61/b321616ce76cde487e02a66b1a79f899.jpg")
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            Text(post.designerID)
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        
                        // Post Image
                        ForEach(post.photos, id: \.id) { photo in
                            AsyncImage(url: photo.imageURL)
                                .scaledToFill()
                                .frame(height: 300)
                                .clipped()
                        }
                        
                        // Like and Comment Icons
                        HStack {
                            Image(systemName: "heart")
                            Image(systemName: "bubble.right")
                            Image(systemName: "paperplane")
                            Spacer()
                            Image(systemName: "bookmark")
                        }
                        .font(.title2)
                        .padding(.horizontal)
                        
                        // Description and Comments
                        if let description = post.description {
                            Text(description)
                                .padding(.horizontal)
                        }
                        
                        // Timestamp
                        Text(post.timestamp)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                    }
                    .padding(.bottom)
                }
            }
            .padding(.top, 0)  // 여기에 패딩을 0으로 설정
            .navigationBarTitle("내 게시글", displayMode: .large)
        }
    }
}

struct DMPostView_Previews: PreviewProvider {
    static var previews: some View {
        DMPostView()
    }
}
