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
                                if post.id == postViewModel.posts.last?.id {
                                    Task {
                                        await postViewModel.fetchPosts() // 다음 페이지를 가져오는 함수 호출
                                        
                                    }
                                }
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
                Task {
                    // 초기 페이지 로드
                    await postViewModel.fetchPosts()
                }
            }
        }
    }
}

#Preview {
    CMRecommendPostView()
}
