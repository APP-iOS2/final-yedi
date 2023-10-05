//
//  DMGridView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/26.
//

import SwiftUI
import FirebaseFirestore

// MARK: - DMGridView (내 게시물 그리드 뷰)
struct DMGridView: View {
    @State var posts: [Post] = []
    @EnvironmentObject var userAuth: UserAuth // UserAuth 객체를 주입
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    let imageSize: CGFloat = 174

    
    var body: some View {
        NavigationStack {
            GridContentView(posts: posts, columns: columns, imageSize: imageSize)
                .background(Color.gray.opacity(0.1))
                .navigationTitle("내 게시물")
                .navigationBarItems(trailing:
                    NavigationLink(destination: DMNewPostView()) {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(.black)
                    }
                )
                .onAppear() {
                    fetchPostsFromFirestore()
                }
        }
    }
    
    private func fetchPostsFromFirestore() {
        let db = Firestore.firestore()
        
        guard let currentDesignerID = userAuth.currentDesignerID else {
            print("No designer is currently logged in.")
            return
        }
        
        db.collection("posts")
          .whereField("designerID", isEqualTo: currentDesignerID) // 현재 디자이너 아이디로 필터링
          .addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            self.posts = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Post.self)
            }
        }
    }
    
    // MARK: - GridContentView (그리드 형식의 컨텐츠 뷰)
    struct GridContentView: View {
        let posts: [Post]
        let columns: [GridItem]
        let imageSize: CGFloat
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
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
    
    // MARK: - PostThumbnail (게시물 썸네일 뷰)
    struct PostThumbnail: View {
        let post: Post
        let imageSize: CGFloat
        
        var body: some View {
            VStack(alignment: .center, spacing: 8) {
                Group {
                    if let urlString = post.photos.first?.imageURL {
                        DMAsyncImage(url: urlString)
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(12)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(12)
                    }
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                
                Text(post.title)
                    .font(.caption)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    DMGridView()
        .environmentObject(UserAuth())
}