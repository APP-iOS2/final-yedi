//
//  CMLikedPostListView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

/// 찜한 게시물 리스트 뷰
struct CMLikedPostListView: View {
    // MARK: - Properties
    /// 유저 Auth 관리 뷰 모델
    @EnvironmentObject var userAuth: UserAuth
    /// 고객 찜한 게시물 뷰 모델
    @StateObject private var likedPostViewModel = CMLikedPostViewModel()
    /// LazyVGrid의 columns 세팅 변수

    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    // MARK: - Body
    var body: some View {
        VStack {
            if likedPostViewModel.likedPosts.isEmpty {
                Text("찜한 게시물이 없습니다.")
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 1) {
                        ForEach(likedPostViewModel.likedPosts, id: \.id) { post in
                            LikedPostCellView(post: post)
                        }
                    }
                }
            }
        }
        .onAppear {
            if let clientID = userAuth.currentClientID {
                likedPostViewModel.fetchLikedPosts(forClientID: clientID)
            }
        }
    }
}

/// 찜한 게시물 셀 뷰
struct LikedPostCellView: View {
    // MARK: - Properties
    /// 표시할 포스트 인스턴스
    let post: Post
    
    /// 스크린 width에 따른 이미즈 크기 지정 변수
    private let imageDimension: CGFloat = (screenWidth / 3) - 5
    
    // MARK: - Body
    var body: some View {
        NavigationLink(destination: CMFeedDetailView(post: post)) {
            // 이미지와 아이콘을 겹치기 위해 ZStack 사용
            ZStack(alignment: .topTrailing) {
                DMAsyncImage(url: post.photos[0].imageURL)
                    .scaledToFill()
                    .frame(width: imageDimension, height: imageDimension)
                    .clipped()
                
                // 이미지가 여러 장인 경우 아이콘 표시
                if post.photos.count > 1 {
                    Image(systemName: "square.on.square.fill")
                        .foregroundColor(.white)
                        .padding(5)
                }
            }
        }
    }
}

#Preview {
    CMLikedPostListView()
        .environmentObject(UserAuth())
        .environmentObject(CMLikedPostViewModel())
}
