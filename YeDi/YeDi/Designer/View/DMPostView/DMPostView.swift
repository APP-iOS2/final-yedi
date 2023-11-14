//
// DMPostView.swift
// YeDi
//
// Created by 박찬호 on 2023/09/25.
//

import SwiftUI

/// 디자이너 포스트 뷰
struct DMPostView: View {
    let post: Post
    
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let size = proxy.size
            
            DMPostDetailView(selectedPost: post, safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            // ToDo: Fetch Data
        }
    }
}
