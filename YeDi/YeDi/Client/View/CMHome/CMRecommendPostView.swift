//
//  CMRecommendPostView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/30.
//

import SwiftUI

struct CMRecommendPostView: View {
    @StateObject var postViewModel = CMPostViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(content: {
                    ForEach(postViewModel.posts, id: \.id) { post in
                        CMHomeCellView(post: post)
                            .task {
                                // 사용자가 스크롤을 끝까지 내렸을 때, 마지막 게시물이 보이면 다음 페이지를 가져옴
                                if post.id == postViewModel.posts.last?.id {
                                    await postViewModel.fetchPosts()
                                    
                                }
                            }
                    }
                })
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await postViewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    CMRecommendPostView()
}
