//
//  CMRecommendPostView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/30.
//

import SwiftUI

struct CMRecommendPostView: View {
    @ObservedObject var postViewModel = CMPostViewModel()
    
    var body: some View {
        NavigationStack {
            // MARK: Post
            ScrollView {
                LazyVStack(content: {
                    ForEach(postViewModel.posts, id: \.id) { post in
                        CMHomeCell(post: post)
                            .onAppear {
                                // 사용자가 스크롤을 끝까지 내렸을 때, 마지막 게시물이 보이면 다음 페이지를 가져옴
                                if let lastPost = postViewModel.posts.last, post.id == lastPost.id {
                                    Task {
                                        await postViewModel.fetchNextPageOfPosts()
                                    }
                                }
                                print("====On Appered!!==== \(post) ")
                            }
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("YeDi")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .onAppear {
                // 초기 게시물 로드
                Task {
                    await postViewModel.fetchInitialPosts()
                }
            }
        }
    }
}

#Preview {
    CMRecommendPostView()
}
