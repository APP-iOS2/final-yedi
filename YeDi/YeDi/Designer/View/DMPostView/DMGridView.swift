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
                .background(Color.gray.opacity(0.1))
                .navigationTitle("내 게시물")
                .navigationBarItems(trailing:
                    NavigationLink(destination: DMNewPostView()) {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(Color(UIColor.label))
                    }
                )
                .onAppear() {
                    postViewModel.fetchPostsFromFirestore(userAuth: userAuth)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("YeDi")
                            .font(.title)
                            .fontWeight(.bold)
                    }
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
