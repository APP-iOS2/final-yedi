//
//  DMPostView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMPostView: View {
    let selectedPost: Post  // 선택된 게시글
    @State private var selectedTab = 0  // 현재 선택된 탭 페이지

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
                                .foregroundStyle(Color.black)
                        }
                        NavigationLink(destination: DMProfileView()) {
                            Text("\(selectedPost.location) | \(selectedPost.title)")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // 게시글 사진
                TabView(selection: $selectedTab) {
                    ForEach(Array(selectedPost.photos.enumerated()), id: \.element.id) { index, photo in
                        AsyncImage(url: photo.imageURL)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 350)
                            .clipped()
                            .tag(index)
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: selectedPost.photos.count > 1 ? .automatic : .never))


//                // 커스텀 페이지 인디케이터
//                if selectedPost.photos.count > 1 {
//                    HStack {
//                        Spacer()
//                        ForEach(0..<selectedPost.photos.count, id: \.self) { index in
//                            Circle()
//                                .frame(width: index == selectedTab ? 12 : 8, height: index == selectedTab ? 12 : 8)
//                                .foregroundStyle(index == selectedTab ? Color.blue : Color.gray.opacity(0.5))
//                        }
//                        Spacer()
//                    }
//                    .padding(.vertical, 8)
//                }
                
                // 게시글 설명
                if let description = selectedPost.description {
                    Text(description)
                        .foregroundStyle(Color.black)
                        .padding(.horizontal)
                }
                
                // 게시 시간
                Text(selectedPost.timestamp)
                    .font(.caption)
                    .foregroundStyle(.gray)
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
