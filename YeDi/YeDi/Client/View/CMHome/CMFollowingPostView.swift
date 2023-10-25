//
//  CMFollowingPostView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/30.
//

import SwiftUI

struct CMFollowingPostView: View {
    @EnvironmentObject var userAuth: UserAuth
    @StateObject var postViewModel = CMPostViewModel()
    
    var body: some View {
        NavigationStack {
            // MARK: Post
            VStack {
                if postViewModel.posts.isEmpty {
                    Spacer()
                    Text("팔로잉한 디자이너가 없습니다")
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(content: {
                            ForEach(postViewModel.posts, id: \.id) { post in
                                CMHomeCellView(post: post)
                            }
                        })
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                postViewModel.fetchPostsForFollowedDesigners(clientID: userAuth.currentClientID ?? "")
            }
        }
    }
}

#Preview {
    CMFollowingPostView()
}
