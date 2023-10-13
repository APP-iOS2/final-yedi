//
//  CMFollowingPostView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/30.
//

import SwiftUI

struct CMFollowingPostView: View {
    @EnvironmentObject var userAuth: UserAuth
    @ObservedObject var postViewModel = CMPostViewModel()
    
    var body: some View {
        NavigationStack {
            // MARK: Post
            ScrollView {
                LazyVStack(content: {
                    ForEach(postViewModel.posts, id: \.id) { post in
                        CMHomeCell(post: post)
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
                postViewModel.fetchPostsForFollowedDesigners(clientID: userAuth.currentClientID ?? "")
            }
        }
    }
}

#Preview {
    CMFollowingPostView()
}
