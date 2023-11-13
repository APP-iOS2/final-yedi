//
//  CMLikePostListView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI
import FirebaseFirestore

struct CMLikePostListView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth // 환경 객체로 UserAuth를 사용할 수 있도록 추가
    @StateObject private var viewModel = CMLikePostListViewModel() // 클라이언트가 찜한 게시물을 저장할 배열
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 5
    
    // MARK: - Body
    var body: some View {
        VStack {
            if viewModel.likedPosts.isEmpty {
                Text("찜한 게시물이 없습니다.")
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 1) {
                        ForEach(viewModel.likedPosts, id: \.id) { post in
                            NavigationLink(destination: CMFeedDetailView(post: post)) {
                                ZStack(alignment: .topTrailing) { // 이미지와 아이콘을 겹치기 위해 ZStack 사용
                                    AsnycCacheImage(url: post.photos[0].imageURL)
                                        .scaledToFill()
                                        .frame(width: imageDimension, height: imageDimension)
                                        .clipped()
                                    
                                    if post.photos.count > 1 { // 이미지가 여러 장인 경우에만 아이콘 표시
                                        Image(systemName: "square.on.square.fill")
                                            .foregroundColor(.white)
                                            .padding(10)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if let clientID = userAuth.currentClientID {
                viewModel.fetchLikedPosts(forClientID: clientID)
            }
        }
    }
}

#Preview {
    CMLikePostListView()
        .environmentObject(UserAuth())
}
