import SwiftUI
import FirebaseFirestore

/// 내 게시물 그리드 뷰
struct DMGridView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var postViewModel: DMPostViewModel
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
    
    var imageSize: CGFloat {
        (UIScreen.main.bounds.width - (16 * 2 + 16 * 2)) / 3
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            GridContentView(posts: postViewModel.posts, columns: columns, imageSize: imageSize)
                .navigationTitle("내 게시물")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        YdIconView(height: 32)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: DMNewPostView()) {
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundStyle(Color(UIColor.label))
                        }
                    }
                }
                .onAppear {
                    print("dfdfdf")
                    postViewModel.fetchPostsFromFirestore(userAuth: userAuth)
                }
        }
    }

    // MARK: - GridContentView (그리드 형식의 컨텐츠 뷰)
    struct GridContentView: View {
        let posts: [Post]
        let columns: [GridItem]
        let imageSize: CGFloat
        
        var body: some View {
            VStack {
                if posts.isEmpty {
                    Text("등록된 게시물이 없습니다.")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(posts, id: \.id) { post in
                                NavigationLink(destination: DMPostView(post: post)) {
                                    PostThumbnail(post: post, imageSize: imageSize)
                                }
                            }
                        }
                        .padding()
                    }
                }
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
                        AsnycCacheImage(url: urlString)
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(5)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(5)
                    }
                }
                .background(Color.white)
                .cornerRadius(5)
                .shadow(color: .gray3, radius: 5, x: 0, y: 3)
                
                Text(post.title)
                    .font(.caption)
                    .foregroundStyle(Color(UIColor.label))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    DMGridView()
        .environmentObject(UserAuth())
        .environmentObject(DMPostViewModel())
}
