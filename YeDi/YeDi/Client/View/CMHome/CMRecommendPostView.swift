//
//  CMRecommendPostView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/30.
//

import SwiftUI

struct CMRecommendPostView: View {
    @ObservedObject var postViewModel = CMPostViewModel()
    
    //    var regions = ["서울", "경기", "인천"]
    //    @State private var selectedRegion = ""
    
    var body: some View {
        NavigationStack {
            //            // MARK: Select Region
            //            HStack {
            //                Menu {
            //                    ForEach(regions, id: \.self) { region in
            //                        Button(action: { selectedRegion = region },
            //                               label: { Text(region)})
            //                    }
            //                } label: {
            //                    Label(selectedRegion.isEmpty ? "위치 선택" : selectedRegion, systemImage: "location")
            //                }
            //                .font(.title3)
            //                .foregroundStyle(.black)
            //                Spacer()
            //            }
            //            .padding()
            
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
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: {CMSearchView()}, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    })
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
