//
//  DMGridView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/26.
//

import SwiftUI
import FirebaseFirestore

struct DMGridView: View {
    @State var posts: [Post] = []  // 게시물 리스트
    
    // 그리드 레이아웃 설정
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    let imageSize: CGFloat = 174  // 이미지 크기
    
    // 초기화 함수에서 Firestore에서 게시물을 가져옵니다.
    init() {
        fetchPostsFromFirestore()
    }
    
    var body: some View {
        NavigationStack {
            GridContentView(posts: posts, columns: columns, imageSize: imageSize)
                .background(Color.gray.opacity(0.1))  // 배경색 설정
                .navigationTitle("내 게시물")  // 네비게이션 타이틀
                .navigationBarItems(trailing:
                    NavigationLink(destination: DMNewPostView()) {  // 새 게시물 버튼
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(.black)
//                            .frame(width: 15, height: 24)
                    }
                )
                .onAppear() {  // 뷰가 나타날 때
                    fetchPostsFromFirestore()  // 게시물을 다시 가져옵니다.
                }
        }
    }
    
    // Firestore에서 게시물을 가져오는 함수
    private func fetchPostsFromFirestore() {
        let db = Firestore.firestore()  // Firestore 인스턴스
        db.collection("posts").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")  // 에러 로그
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")  // 문서 없음 로그
                return
            }
            
            // 게시물 데이터를 매핑합니다.
            self.posts = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Post.self)
            }
            
            print("Fetched \(self.posts.count) posts.")  // 가져온 게시물 수 로그
        }
    }
    
    // 그리드 컨텐츠 뷰
    struct GridContentView: View {
        let posts: [Post]
        let columns: [GridItem]
        let imageSize: CGFloat
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {  // 게시물 그리드
                    ForEach(posts, id: \.id) { post in
                        NavigationLink(destination: DMPostView(selectedPost: post)) {
                            PostThumbnail(post: post, imageSize: imageSize)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // 게시물 썸네일 뷰
    struct PostThumbnail: View {
        let post: Post
        let imageSize: CGFloat
        
        var body: some View {
            VStack(alignment: .center, spacing: 8) {
                Group {
                    if let urlString = post.photos.first?.imageURL {  // 이미지 URL이 있는 경우
                        AsyncImage(url: urlString)
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(12)
                            .clipped()
                    } else {  // 이미지 URL이 없는 경우
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(12)
                    }
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                
                Text(post.title)  // 게시물 제목
                    .font(.caption)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    DMGridView()
}
